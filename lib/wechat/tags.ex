defmodule Wechat.Tags do
  @moduledoc false

  alias Wechat.API
  alias Wechat.TaskSupervisor

  def create(names) when is_list(names), do: run_async_tasks(names, &create/1)
  def create(name) when is_binary(name) do
    API.post "/tags/create", %{tag: %{name: name}}
  end

  def get do
    API.get "/tags/get"
  end

  def update(tags) when is_list(tags), do: run_async_tasks(tags, &update/1)
  def update({id, name}) do
    API.post "/tags/update", %{tag: %{id: id, name: name}}
  end

  def delete(ids) when is_list(ids), do: run_async_tasks(ids, &delete/1)
  def delete(id) do
    API.post "/tags/delete", %{tag: %{id: id}}
  end

  defp run_async_tasks(enums, func) when is_list(enums) and is_function(func) do
    TaskSupervisor
    |> Task.Supervisor.async_stream(enums, func)
    |> Enum.to_list
    |> Keyword.values
  end
end
