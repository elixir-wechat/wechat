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

  def get_users(tag_id, next_openid \\ "") do
    API.post "user/tag/get", %{tagid: tag_id, next_openid: next_openid}
  end

  def tagging_user(tag_id, openid) when is_binary(openid) do
    tagging_users(tag_id, [openid])
  end
  def tagging_users(tag_id, openids) when is_list(openids) do
    API.post "tags/members/batchtagging", %{openid_list: openids, tagid: tag_id}
  end

  def untagging_user(tag_id, openid) when is_binary(openid) do
    untagging_user(tag_id, [openid])
  end
  def untagging_users(tag_id, openids) when is_list(openids) do
    API.post "tags/members/batchuntagging", %{openid_list: openids, tagid: tag_id}
  end

  def get_user_tag_list(openid) do
    API.post("tags/getidlist", %{openid: openid})
  end
end
