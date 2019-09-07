defmodule Wechat.Error do
  @moduledoc """
  Error module.
  """

  defexception [:type, :code, :reason, :response]

  @doc """
  Return API error.
  """
  def message(%{type: :api, code: errcode, reason: errmsg, response: response}),
    do: "API error: #{errcode} - #{errmsg}\n#{inspect(response)}"

  @doc """
  Return HTTP error.
  """
  def message(%{type: :http, code: status_code, response: response}),
    do: "HTTP error: #{status_code}\n#{inspect(response)}"
end
