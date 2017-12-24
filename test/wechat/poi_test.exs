defmodule Wechat.POITest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.POI

  @params "../../fixture/poi_assets/create.json" |> Path.expand(__DIR__) |> File.read! |> Jason.decode!

  @tag pending: true
  test "#create" do
    use_cassette "poi/create" do
      result = POI.add(@params)
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
      assert result["poi_id"]
    end
  end

  @tag pending: true
  test "#get" do
    use_cassette "poi/get" do
      poi_id = "some_id"
      result = POI.get(poi_id)
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
      assert result["business"]
    end
  end

  @tag pending: true
  test "#get_list" do
    use_cassette "poi/get_list" do
      result = POI.get_list(0, 10)
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
      assert is_list(result["business_list"])
      assert is_integer(result["total_count"])
    end
  end

  @tag pending: true
  test "#update" do
    use_cassette "poi/update" do
      data = %{}
      result = POI.update(data)

      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
    end
  end

  @tag pending: true
  test "#delete" do
    use_cassette "poi/delete" do
      id = "poi_id"
      result = POI.delete(id)

      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
    end
  end

  @tag pending: true
  test "#get_wxcategory" do
    use_cassette "poi/get_wxcategory" do
      result = POI.get_wxcategory
      assert is_list(result["category_list"])
    end
  end
end
