defmodule Wechat do
  @moduledoc """
  Use this module to build your own API wrapper for a client.

  ## Config

      config :my_app, MyApp.Wechat,
        appid: "APP_ID",
        secret: "APP_SECRET",
        token: "TOKEN",
        encoding_aes_key: "ENCODING_AES_KEY" # Required if you enabled the encrypt mode

  ## Example

      def MyApp.Wechat do
        use Wechat, otp_app: :my_app

        def users do
          client() |> Wechat.User.get()
        end
      end
  """

  alias Wechat.Client

  @callback client() :: Client.t()

  @callback config() :: Keyword.t()

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour Wechat

      otp_app = Keyword.fetch!(opts, :otp_app)

      @otp_app otp_app

      @impl true
      def config do
        Application.get_env(@otp_app, __MODULE__, [])
      end

      @impl true
      def client do
        Wechat.Client.new(config())
      end

      def access_token do
        Wechat.Client.access_token(client())
      end

      def encrypt_message(msg) do
        Wechat.Client.encrypt_message(client(), msg)
      end

      if Code.ensure_loaded?(Phoenix.Controller) do
        def wechat_config_js(conn, opts \\ []) do
          import Phoenix.Controller, only: [current_url: 1]

          Wechat.Client.wechat_config_js(client(), current_url(conn), opts)
        end
      end
    end
  end
end
