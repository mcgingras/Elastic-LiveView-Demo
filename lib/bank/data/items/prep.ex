defprotocol Bank.Data.Items.Prep do
  @doc """
  I _think_ prep prepares an object so it can be
  indexed into elasticsearch? I need to follow gf-data
  a bit better before confirming if this is true.

  TODO: come back to this documentation.

  params
  ------
  item: item
  """
  def prep(item)
end
