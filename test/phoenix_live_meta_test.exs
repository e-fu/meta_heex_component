defmodule PhoenixLiveMetaTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  setup do
    Application.put_env(:phoenix_live_meta, :defaults, %{
      og_type: "website",
      twitter_card: "summary_large_image",
      locale: "en",
      robots: "index,follow"
    })

    on_exit(fn ->
      Application.delete_env(:phoenix_live_meta, :defaults)
    end)

    :ok
  end

  describe "assign_meta/2" do
    test "assigns meta values to socket" do
      socket = %Phoenix.LiveView.Socket{}

      meta_attrs = [
        page_title: "Test Title",
        meta_description: "Test Description",
        og_title: "Test OG Title"
      ]

      socket = PhoenixLiveMeta.assign_meta(socket, meta_attrs)

      assert socket.assigns.page_title == "Test Title"
      assert socket.assigns.meta_description == "Test Description"
      assert socket.assigns.og_title == "Test OG Title"
    end
  end

  describe "put_meta/2" do
    test "assigns meta values to conn" do
      conn = %Plug.Conn{}

      meta_attrs = [
        page_title: "Test Title",
        meta_description: "Test Description",
        og_title: "Test OG Title"
      ]

      conn = PhoenixLiveMeta.put_meta(conn, meta_attrs)

      assert conn.assigns.page_title == "Test Title"
      assert conn.assigns.meta_description == "Test Description"
      assert conn.assigns.og_title == "Test OG Title"
    end
  end

  test "live_meta_tags/1 renders meta tags" do
    rendered_html =
      render_component(&PhoenixLiveMeta.live_meta_tags/1, %{
        meta_description: "Test Description",
        meta_keywords: "test,keywords",
        author: "Test Author",
        og_title: "Test OG Title"
      })

    assert rendered_html =~ ~s(meta name="description" content="Test Description")
    assert rendered_html =~ ~s(meta name="keywords" content="test,keywords")
    assert rendered_html =~ ~s(meta name="author" content="Test Author")
    assert rendered_html =~ ~s(meta property="og:title" content="Test OG Title")
  end
end
