if Code.ensure_loaded?(Redix) do
  defmodule Wechat.Adapter.Redis do
    @moduledoc """
    Redis adapter, save data in redis.

    To use this adapter, add config like following:
    ```
    config :Wechat,
      adapter: Wechat.Adapter.Redis,
      redis_url: "redis://localhost:6379/0"
    ```
    """

    import Wechat.Config

    @behaviour Wechat.Adapter

    def child_spec(opts) do
      %{
        id: __MODULE__,
        start: {__MODULE__, :start_link, [opts]},
        type: :worker,
        restart: :permanent,
        shutdown: 500
      }
    end

    def start_link(_) do
      redis_url = config()[:redis_url]
      Redix.start_link(redis_url, name: __MODULE__)
    end

    @impl true
    def read_token(appid) do
      key = k_access_token(appid)

      case Redix.command!(__MODULE__, ["GET", key]) do
        value when is_binary(value) ->
          token = :erlang.binary_to_term(value)
          {:ok, token}

        _ ->
          :error
      end
    end

    @impl true
    def write_token(appid, token) do
      key = k_access_token(appid)
      value = :erlang.term_to_binary(token)

      "OK" = Redix.command!(__MODULE__, ["SET", key, value])
      :ok
    end

    defp k_access_token(appid), do: "#{appid}:access_token"
  end
end
