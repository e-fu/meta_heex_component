defmodule PhoenixLiveMeta.Components.MetaTagsTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias PhoenixLiveMeta.Components.MetaTags

  setup do
    # Set up test defaults
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

  @required_attrs %{
    meta_description: "Test Description",
    meta_keywords: "test,keywords",
    author: "Test Author",
    og_title: "Test OG Title"
  }

  describe "live_meta_tags/1" do
    test "renders required meta tags" do
      html = render_component(&MetaTags.live_meta_tags/1, @required_attrs)

      assert html =~ ~s{<meta name="description" content="Test Description"}
      assert html =~ ~s{<meta name="keywords" content="test,keywords"}
      assert html =~ ~s{<meta name="author" content="Test Author"}
      assert html =~ ~s{<meta property="og:title" content="Test OG Title"}
    end

    test "renders optional meta tags when provided" do
      attrs =
        Map.merge(@required_attrs, %{
          og_image: "test.jpg",
          twitter_site: "@testsite",
          canonical_url: "https://example.com",
          viewport: "width=device-width, initial-scale=1"
        })

      html = render_component(&MetaTags.live_meta_tags/1, attrs)

      assert html =~ ~s{<meta property="og:image" content="test.jpg"}
      assert html =~ ~s{<meta name="twitter:site" content="@testsite"}
      assert html =~ ~s{<link rel="canonical" href="https://example.com"}
      assert html =~ ~s{<meta name="viewport" content="width=device-width, initial-scale=1"}
    end

    test "uses config defaults when optional attributes are not provided" do
      html = render_component(&MetaTags.live_meta_tags/1, @required_attrs)

      assert html =~ ~s{<meta property="og:type" content="website"}
      assert html =~ ~s{<meta name="language" content="en"}
      assert html =~ ~s{<meta name="robots" content="index,follow"}
      assert html =~ ~s{<meta name="twitter:card" content="summary_large_image"}
    end

    test "fallback values work correctly" do
      html = render_component(&MetaTags.live_meta_tags/1, @required_attrs)

      # Check og fallbacks
      assert html =~ ~s{<meta property="og:description" content="Test Description"}
      assert html =~ ~s{<meta property="og:title" content="Test OG Title"}

      # Check twitter fallbacks
      assert html =~ ~s{<meta name="twitter:title" content="Test OG Title"}
      assert html =~ ~s{<meta name="twitter:description" content="Test Description"}
    end

    test "renders additional meta tags" do
      attrs =
        Map.put(@required_attrs, :additional_meta_tags, [
          %{name: "robots", content: "noindex"},
          %{property: "og:locale", content: "en_US"}
        ])

      html = render_component(&MetaTags.live_meta_tags/1, attrs)

      assert html =~ ~s{<meta name="robots" content="noindex"}
      assert html =~ ~s{<meta property="og:locale" content="en_US"}
    end

    test "og_description falls back to meta_description" do
      html = render_component(&MetaTags.live_meta_tags/1, @required_attrs)

      assert html =~ ~s{<meta property="og:description" content="Test Description"}
    end

    test "twitter_title falls back to og_title" do
      html = render_component(&MetaTags.live_meta_tags/1, @required_attrs)

      assert html =~ ~s{<meta name="twitter:title" content="Test OG Title"}
    end
  end

  describe "assign_meta/2" do
    test "assigns meta values to socket" do
      socket = %Phoenix.LiveView.Socket{}

      meta_attrs = [
        page_title: "Test Title",
        meta_description: "Test Description"
      ]

      socket = MetaTags.assign_meta(socket, meta_attrs)

      assert socket.assigns.page_title == "Test Title"
      assert socket.assigns.meta_description == "Test Description"
    end
  end
end