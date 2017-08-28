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

  @tag_id 2
  @open_id "oGrvrjnkVgClrO4EdP-dWbTq8LuU"

  test "#get_users" do
    use_cassette "tag_get_users" do
      %{"count" => count, "data" => data, "next_openid" => openid} = Tags.get_users(@tag_id)

      assert is_integer(count)
      assert is_list(data["openid"])
      assert is_binary(openid)
    end
  end

  test "#tagging_users" do
    use_cassette "tag_tagging_users" do
      result = Tags.tagging_users(@tag_id, [@open_id])

      assert result["errcode"] == 0
      assert result["errmsg"]  == "ok"
    end
  end

  test "#untagging_users" do
    use_cassette "tag_untagging_users" do
      result = Tags.untagging_users(@tag_id, [@open_id])

      assert result["errcode"] == 0
      assert result["errmsg"]  == "ok"
    end
  end

  test "#get_user_tag_list" do
    use_cassette "tag_get_user_tag_list" do
      result = Tags.get_user_tag_list(@open_id)

      tlist = result["tagid_list"]
      assert is_list(tlist)
      assert Enum.any?(tlist, & &1 == @tag_id)
    end
  end
end
