defmodule Bank.Data.Search.Response.Getters do
  @moduledoc false
  def get_boolean(value) when is_boolean(value), do: value
  def get_string(value) when is_binary(value), do: value
  def get_optional_string(value) when is_binary(value) or is_nil(value), do: value
  def get_integer(value) when is_integer(value), do: value
  def get_float(value) when is_float(value), do: value
  def get_optional_float(value) when is_float(value) or is_nil(value), do: value
  def get_list(value) when is_list(value), do: value
  def get_map(value) when is_map(value), do: value
  def get_optional_map(value) when is_map(value) or is_nil(value), do: value

  def get_float_from_string(value) when is_binary(value) do
    {float, _} = Float.parse(value)
    float
  end
end

defmodule Bank.Data.Search.Response do
  @moduledoc """
  Functions dealing with responses coming out of Elasticsearch. (Or rather, coming
  out of the Elasticsearch Elixir package.)

  ## Response structure

  ```
  %{
    "_shards" => %{"total" => 3, "successful" => 3, "skipped" => 0, "failed" => 0},
    "timed_out" => false
    "took" => 1    #  time in ms
    "hits" => %{
      # how many records, and to what precision; for exact numbers we want "eq"
      "total" => %{"relation" => "gte", "value" => 10000},
      "max_score" => 2.2444,
      "hits" => [
        %{
          "_id" => "...",
          "_index" => "...",
          "_score" => 2.333,
          "_type" => "_doc",
          "_source" => %{
            # the indexed document fields are here
          }

  """
  import Bank.Data.Search.Response.Getters
  alias Bank.Data.Search.Response.{HitsInfo, Hit}

  @enforce_keys [:timed_out, :took, :hits, :results]
  defstruct [:_scroll_id, :_shards, :timed_out, :took, :hits, :results]

  @doc """
  responsible for parsing the raw ES response into something consumable by the front end.
  Returns a list of Frob objects as specified by the decoder.

  returns
  {
    _scroll_id: not sure what this is.
    timed_out: bool if response times out?
    took: not sure what this is.
    hits: raw hit response.
    results: parsed results -> FROB.
  }

  params
  ------
  raw: raw ES response (comes from Actions.Search)
  decoder: the frob wrapper (comes from Items.Type.{-type-})
  """
  def parse!(raw, decoder \\ nil) do
    hits_info = HitsInfo.parse!(raw["hits"])

    %__MODULE__{
      _scroll_id: get_optional_string(raw["_scroll_id"]),
      timed_out: get_boolean(raw["timed_out"]),
      took: get_integer(raw["took"]),
      hits: hits_info,
      results: extract_results(hits_info, decoder)
    }
  end

  defp extract_results(hits_info, decoder) do
    hits_info.hits |> Enum.map(fn hit -> invert_hit(hit, decoder) end)
  end

  # ASK ERIK - what is this responsible for?
  # when would we not pass in the wrapper/decoder
  # and what is the expected behavior?
  defp invert_hit(hit, decoder) when is_nil(decoder) do
    Map.merge(hit._source, %{_meta: Hit.meta(hit)})
  end

  # ASK ERIK - whats the point of having this function
  # why not just pattern match on hit_to_struct/2?
  defp invert_hit(hit, decoder), do: hit_to_struct(hit, decoder)

  # add error catch here
  def hit_to_struct(hit, decoder) do
    atomized = for {k, v} <- hit["_source"], into: %{}, do: {String.to_existing_atom(k), v}
    struct(decoder, atomized)
  end

  defmodule HitsInfo do
    @moduledoc """
    The top-level "hits" structure that is actually metadata
    about the hits.
    """
    @enforce_keys [:total, :max_score, :hits]
    defstruct [:total, :max_score, :hits]

    import Bank.Data.Search.Response.Getters

    alias Bank.Data.Search.Response.HitsInfoTotal
    alias Bank.Data.Search.Response.Hit

    def parse!(hits_info) do
      %__MODULE__{
        max_score: get_optional_float(hits_info["max_score"]),
        total: HitsInfoTotal.parse!(hits_info["total"]),
        # |> Enum.map(&Hit.parse!/1)
        hits: get_list(hits_info["hits"])
      }
    end
  end

  defmodule HitsInfoTotal do
    @moduledoc """
    How many records, and whether that's at least, exactly, etc.
    """
    @enforce_keys [:relation, :value]
    defstruct [:relation, :value]

    import Bank.Data.Search.Response.Getters

    def parse!(hits_info_total) do
      %__MODULE__{
        relation: get_string(hits_info_total["relation"]),
        value: get_integer(hits_info_total["value"])
      }
    end
  end

  defmodule Hit do
    @moduledoc """
    A single hit. The result comes back from ES
    """
    @enforce_keys [:_id, :_index, :_score, :_type, :_source]
    defstruct [:_id, :_index, :_score, :_type, :_source]

    import Bank.Data.Search.Response.Getters

    def parse!(hit) do
      %__MODULE__{
        _id: get_string(hit["_id"]),
        _index: get_string(hit["_index"]),
        _type: get_string(hit["_type"]),
        _score: get_float(hit["_score"]),
        _source: get_map(hit["_source"])
      }
    end

    def meta(%__MODULE__{} = parsed_hit), do: parsed_hit |> Map.delete(:_source)
  end
end
