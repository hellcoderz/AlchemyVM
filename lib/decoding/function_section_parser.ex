defmodule WaspVM.Decoder.FunctionSectionParser do
  alias WaspVM.LEB128

  @spec parse(WaspVM.Module) :: WaspVM.Module
  def parse(module) do
    values = Map.get(module.sections, 3)
    indexes = if values !== nil, do: parse_type_entry(values), else: []

    Map.put(module, :function_types, Enum.reverse(indexes))
  end

  @spec parse_type_entry(Binary) :: List
  defp parse_type_entry(entry) do
    {count, entry} = LEB128.decode(entry)
    parse_type_entry(:indexing, [], count, entry)
  end

  defp parse_type_entry(:indexing, v, _n, ""), do: v
  defp parse_type_entry(:indexing, v, n, entry) do
    {id, rem} = LEB128.decode(entry)
  	parse_type_entry(:indexing, [id | v], n - 1, rem)
  end
end
