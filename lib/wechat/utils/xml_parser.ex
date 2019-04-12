defmodule Wechat.Utils.XMLParser do
  @moduledoc """
  Parse XML message.
  """

  import Record, only: [defrecord: 2, extract: 2]

  defrecord :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def parse(xml) do
    {doc, _} = xml |> :binary.bin_to_list() |> :xmerl_scan.string()
    elements = :xmerl_xpath.string('/xml/*', doc)
    Enum.reduce(elements, %{}, &acc_element/2)
  end

  defp acc_element(element, acc) do
    element = xmlElement(element)
    key = element[:name]
    value = element[:content] |> value()
    Map.put(acc, key, value)
  end

  defp value([]), do: ""

  defp value([text]) do
    text
    |> xmlText()
    |> Keyword.get(:value)
    |> String.Chars.to_string()
  end
end
