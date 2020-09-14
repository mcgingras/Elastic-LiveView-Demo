defprotocol Bank.Data.Items.Item do
  @moduledoc """
  Protocol to be implemented on all front-end types,
  i.e., everything returned by Items.generate.
  """

  #  @spec item :: binary()
  def type(item)

  #  @spec item :: binary()
  def id(item)

  #  @spec item :: binary()
  def name(item)
end
