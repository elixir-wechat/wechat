if Code.ensure_loaded?(Bypass) do
  defmodule WechatBypass.Assertion do
    @moduledoc false

    use ExUnit.CaseTemplate

    def run(conn, asserts) do
      Enum.each(asserts, &assert_on(conn, &1))
      conn = put_resp_headers(conn, asserts)
      send_resp(conn, asserts)
    end

    defp assert_on(conn, {:method, method}), do: conn.method == method
    defp assert_on(conn, {:path, path}), do: conn.request_path == path

    defp assert_on(conn, {:headers, headers}) do
      conn_headers = conn.req_headers |> Enum.into(%{})
      Enum.each(headers, fn {k, v} -> conn_headers[k] == v end)
    end

    defp assert_on(_, _), do: :ok

    defp put_resp_headers(conn, %{resp_headers: headers}) do
      Enum.reduce(headers, conn, fn {key, value}, conn ->
        Plug.Conn.put_resp_header(conn, key, value)
      end)
    end

    defp put_resp_headers(conn, _),
      do: Plug.Conn.put_resp_content_type(conn, "application/json")

    defp send_resp(conn, %{status_code: status_code, response_body: response_body}),
      do: Plug.Conn.resp(conn, status_code, response_body)

    defp send_resp(conn, %{status_code: status_code, path: path, use_fixture: true}),
      do: Plug.Conn.resp(conn, status_code, fixture_file(path))

    defp send_resp(conn, %{status_code: status_code}),
      do: Plug.Conn.resp(conn, status_code, "")

    defp send_resp(conn, _), do: Plug.Conn.resp(conn, 200, "")

    defp fixture_file(path),
      do: Path.expand("../../test/fixtures#{path}.json", __DIR__) |> File.read!()
  end
end
