defmodule Wechat do
  @moduledoc false

  alias Wechat.{Client, Error}

  @access_token_errcodes [40001, 40014, 41001, 42001]

  def get(client, path, opts \\ []) do
    do_request(client, :get, path, "", opts)
  end

  def raw_get(client, path, opts \\ []) do
    raw_request(client, :get, path, "", opts)
  end

  def post(client, path, body, opts \\ [])

  def post(client, path, body, opts) when is_map(body) do
    body = Jason.encode!(body)
    do_request(client, :post, path, body, opts)
  end

  def post(client, path, body, opts),
    do: do_request(client, :post, path, body, opts)

  defp raw_request(client, method, path, body, opts) do
    url = client.endpoint <> path

    HTTPoison.request!(method, url, body, [], opts)
    |> process_response()
  end

  defp do_request(client, method, path, body, opts, retries \\ 3) do
    url = client.endpoint <> path
    opts = with_auth(opts, client.auth)

    retry? =
      case client.auth do
        %{appid: _} -> retries > 0
        _ -> false
      end

    result =
      HTTPoison.request!(method, url, body, [], opts)
      |> process_response()

    case result do
      {:ok, body} ->
        {:ok, body}

      {:error, %Error{code: code}} when code in @access_token_errcodes and retry? ->
        client
        |> Client.get_token!()
        |> do_request(method, path, body, opts, retries - 1)

      {:error, error} ->
        {:error, error}
    end
  end

  defp with_auth(opts, %{access_token: access_token}),
    do: add_param_to_opts(opts, :access_token, access_token)

  defp with_auth(opts, %{appid: _} = auth) do
    access_token = Client.access_token(auth)
    add_param_to_opts(opts, :access_token, access_token)
  end

  defp add_param_to_opts(opts, name, value) do
    if Keyword.has_key?(opts, :params) do
      update_in(opts[:params], &Keyword.put(&1, name, value))
    else
      Keyword.put(opts, :params, [{name, value}])
    end
  end

  defp process_response(%{status_code: 200, body: body, headers: headers} = response) do
    case handle_body(body, headers) do
      %{"errcode" => errcode, "errmsg" => errmsg} when errcode > 0 ->
        {:error, %Error{type: :api, code: errcode, reason: errmsg, response: response}}

      body ->
        {:ok, body}
    end
  end

  defp process_response(%{status_code: status_code} = response),
    do: raise(%Error{type: :http, code: status_code, response: response})

  defp handle_body(body, headers) when is_list(headers) do
    content_type = content_type(headers)
    handle_body(body, content_type)
  end

  defp handle_body(body, "application/json"), do: Jason.decode!(body)
  defp handle_body(body, "text/plain"), do: Jason.decode!(body)
  defp handle_body(body, _), do: body

  defp content_type([]), do: ""

  defp content_type([{key, value} | t]) do
    cond do
      String.match?(key, ~r/content-type/i) ->
        [content_type | _] = String.split(value, ";")
        content_type

      true ->
        content_type(t)
    end
  end
end
