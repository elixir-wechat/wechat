defmodule Wechat.Error do
  @moduledoc false

  defexception [:type, :code, :reason, :response]

  def message(%{type: :api, code: errcode, reason: errmsg, response: response}),
    do: "API error: #{errcode} - #{errmsg}\n#{inspect(response)}"

  def message(%{type: :http, code: status_code, response: response}),
    do: "HTTP error: #{status_code}\n#{inspect(response)}"
end
