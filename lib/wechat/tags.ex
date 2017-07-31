defmodule Wechat.Tags do
  @moduledoc false

  alias Wechat.API

  def create(names) do
    tags = names
           |> Enum.map(&({:tag, %{name: &1}}))
           |> Enum.into(%{})
    API.post "/tags/create", tags
  end

  def get do
    API.get "/tags/get"
  end

  def update(tags) do
    tags = tags
           |> Enum.map(fn {id, name} -> {:tag, %{id: id, name: name}} end)
           |> Enum.into(%{})
    API.post "/tags/update", tags
  end

  def delete(ids) do
    tags = ids
           |> Enum.map(&({:tag, %{id: &1}}))
           |> Enum.into(%{})
    API.post "/tags/delete", tags
  end
end
