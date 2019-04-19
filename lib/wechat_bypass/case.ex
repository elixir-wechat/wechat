if Code.ensure_loaded?(Bypass) do
  defmodule WechatBypass.Case do
    @moduledoc false

    use ExUnit.CaseTemplate

    alias Wechat.{Config, Client, AccessToken}
    alias WechatBypass.Assertion

    setup context do
      case setup_bypass_server(context) do
        {:ok, bypass} ->
          client = client(bypass)
          onexit(client)
          [bypass: bypass, client: client]

        :error ->
          :ok
      end
    end

    defp setup_bypass_server(%{bypass_api: asserts}) do
      bypass = Bypass.open()
      Bypass.expect(bypass, &Assertion.run(&1, asserts))
      {:ok, bypass}
    end

    defp setup_bypass_server(_), do: :error

    defp client(bypass) do
      Client.new(
        appid: "test_appid",
        secret: "test_secret",
        endpoint: "http://localhost:#{bypass.port}"
      )
    end

    defp onexit(%{appid: appid}) do
      on_exit(fn -> Config.adapter().write_token(appid, %AccessToken{}) end)
    end
  end
end
