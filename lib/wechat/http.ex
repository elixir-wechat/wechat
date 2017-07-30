defmodule Wechat.HTTP do
  @moduledoc false

  defmacro __using__(opts) do
    quote do
      use HTTPoison.Base

      def process_url(url) do
        Path.join(unquote(opts)[:host], url)
      end

      def process_response_body(body) do
        case Poison.decode(body) do
          {:ok, value} -> value # json
          {:error, :invalid, _} -> body # raw
        end
      end

      def process_request_options(opts) do
        case Map.has_key?(opts[:params], :grant_type) do
          true -> opts
          false -> with_access_token(opts)
        end
      end

      defp with_access_token(opts) do
        params = Map.put_new(opts[:params], :access_token, Wechat.access_token)
        Keyword.put(opts, :params, params)
      end
    end
  end
end
