defmodule Wechat.TagsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.Tags

  @tag_names Enum.map(1..3, & "awesome tag #{&1}")

  test "#create" do
    use_cassette "tag_create" do
      # exvcr always return the first result here :< and we check the tags from getter :D
      Tags.create(@tag_names)
      %{"tags" => tags} = Tags.get()

      recv_names = Enum.map(tags, & Map.get(&1, "name"))
      for n <- @tag_names do
        assert n in recv_names
      end
    end
  end

  test "#get" do
    use_cassette "tag_get" do
      %{"tags" => tags} = Tags.get()
      assert is_list(tags)

      tag_names = Enum.map(tags, & Map.get(&1, "name"))
      for name <- @tag_names do
        assert name in tag_names
      end
    end
  end

  @tag_ids [115, 116, 117] #grab ids from exvcr tag_get.json cassettes
  test "update" do
    use_cassette "tag_update" do
      input = Enum.map(@tag_ids, & {&1, "lame tag #{&1}"})

      result = Tags.update(input)

      for ret <- result do
        assert ret["errcode"] == 0
        assert ret["errmsg"] == "ok"
      end
    end
  end

  test "#delete" do
    use_cassette "tag_delete" do
      result = Tags.delete(@tag_ids)

      for ret <- result do
        assert ret["errcode"] == 0
        assert ret["errmsg"] == "ok"
      end
    end
  end
end
