defmodule Wechat.HTTP do
  @moduledoc """
  Provides a wrapper layer for HTTPoison.
  This module is meant to be `use`'d in custom modules.

      defmodule HTTPBin do
        use Wechat.HTTP, host: "https://httpbin.org/"
        def test_get do
          get "/get"
        end
        def test_post do
          post "/post", %{foo: :bar}
        end
      end
  """

  use HTTPoison.Base

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

  defmacro __using__(opts) do
    quote do
      def get(url, params \\ %{}) do
        unquote(opts[:host])
          |> Path.join(url)
          |> Wechat.HTTP.get!([], params: params)
          |> Map.fetch!(:body)
      end

      def post(url, body, params \\ %{}) do
        body =
          case body do
            {:multipart, _} -> body
            _ -> Poison.encode!(body)
          end

        unquote(opts[:host])
        |> Path.join(url)
        |> Wechat.HTTP.post!(body, [], params: params)
        |> Map.fetch!(:body)
      end
    end
  end
end
