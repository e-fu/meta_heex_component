defmodule MetaHeexComponentTest do
  use ExUnit.Case, async: true
  use Phoenix.ConnTest

  import Phoenix.LiveViewTest

  @endpoint MyApp.Endpoint

  setup do
    # Set up test defaults
    Application.put_env(:meta_heex_component, :defaults, %{
      locale: "en",
      robots: "index,follow"
    })

    on_exit(fn ->
      Application.delete_env(:meta_heex_component, :defaults)
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

      socket = MetaHeexComponent.assign_meta(socket, meta_attrs)

      assert socket.assigns.page_title == "Test Title"
      assert socket.assigns.meta_description == "Test Description"
      assert socket.assigns.og_title == "Test OG Title"
    end
  end

  describe "put_meta/2" do
    test "assigns meta values to conn" do
      conn = build_conn()

      meta_attrs = [
        meta_description: "Test Description",
        og_title: "Test OG Title"
      ]

      conn = MetaHeexComponent.put_meta(conn, meta_attrs)

      # Check individual assigns
      assert conn.assigns.meta_description == "Test Description"
      assert conn.assigns.og_title == "Test OG Title"

      # Check meta_tags map
      assert conn.assigns.meta_tags.meta_description == "Test Description"
      assert conn.assigns.meta_tags.og_title == "Test OG Title"
    end

    test "merges with existing meta_tags" do
      conn =
        build_conn()
        |> MetaHeexComponent.put_meta(meta_description: "First")
        |> MetaHeexComponent.put_meta(og_title: "Second")

      assert conn.assigns.meta_tags.meta_description == "First"
      assert conn.assigns.meta_tags.og_title == "Second"
    end

    test "meta tags from controller show up in rendered output" do
      meta_attrs = [
        meta_description: "Test Description",
        og_title: "Test OG Title"
      ]

      # Use get_meta_tags to merge defaults and meta_tags
      assigns = %{meta_tags: Map.new(meta_attrs)}
      merged_assigns = MetaHeexComponent.get_meta_tags(assigns)

      html =
        render_component(&MetaHeexComponent.Components.MetaTags.live_meta_tags/1, merged_assigns)

      assert html =~ ~s{<meta name="description" content="Test Description"}
      assert html =~ ~s{<meta property="og:title" content="Test OG Title"}
    end
  end

  test "live_meta_tags/1 renders meta tags" do
    rendered_html =
      render_component(&MetaHeexComponent.live_meta_tags/1, %{
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
