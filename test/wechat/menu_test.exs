defmodule Wechat.MenuTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

    alias Wechat.Menu

    @json "./fixture/menu_assets/menu.json" |> Path.expand("./") |> File.read! |> Jason.decode!

    test "#create" do
      use_cassette "menu_create" do
        result = Menu.create(@json)
        assert_ok(result)
      end
    end

    test "#get" do
      use_cassette "menu_get" do
        result = Menu.get()
        assert(match? %{"menu" => @json}, result)
      end
    end

    test "#delete" do
      use_cassette "menu_delete" do
        result = Menu.delete()
        assert_ok(result)
      end
    end

    @cond_json "./fixture/menu_assets/menu_conditional.json" |> Path.expand("./") |> File.read! |> Jason.decode!
    @menu_id 498_512_099
    test "#create_contional" do
      use_cassette "menu_create_conditional" do
        result = Menu.create_conditional(@cond_json)
        assert result["menuid"] == @menu_id
      end
    end

    test "#delete_conditional" do
      use_cassette "menu_delete_conditional" do
        result = Menu.delete_conditional(@menu_id)
        assert_ok(result)
      end
    end

    test "#try_match" do
      use_cassette "menu_try_match" do
        open_id_or_wechat_id = "oGrvrjnkVgClrO4EdP-dWbTq8LuU"
        result = Menu.try_match(open_id_or_wechat_id)
        assert result["menu"]
      end
    end

    test "#get_self_menu" do
      use_cassette "menu_get_self_menu" do
        result = Menu.get_self_menu()
        assert result["selfmenu_info"]
      end
    end

    defp assert_ok(result) do
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
    end
  end
