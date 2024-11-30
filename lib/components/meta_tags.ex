defmodule PhoenixLiveMeta.Components.MetaTags do
  @moduledoc """
  Provides components for rendering meta tags in Phoenix applications.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.Socket

  @default_viewport "width=device-width, initial-scale=1"

  @type meta_tag :: %{
          optional(:name) => String.t(),
          optional(:property) => String.t(),
          content: String.t()
        }

  # Required attributes
  attr :meta_description, :string, required: true, doc: "Primary meta description for SEO"
  attr :meta_keywords, :string, required: true, doc: "Keywords for SEO"
  attr :author, :string, required: true, doc: "Content author"
  attr :og_title, :string, required: true, doc: "Open Graph title"

  # Optional attributes with defaults
  attr :og_description, :string, default: nil
  attr :og_type, :string, default: "website"
  attr :og_image, :string, default: nil
  attr :og_url, :string, default: nil
  attr :twitter_card, :string, default: "summary_large_image"
  attr :twitter_site, :string, default: nil
  attr :twitter_title, :string, default: nil
  attr :twitter_description, :string, default: nil
  attr :twitter_image, :string, default: nil
  attr :canonical_url, :string, default: nil
  attr :locale, :string, default: "en"
  attr :viewport, :string, default: @default_viewport
  attr :robots, :string, default: "index,follow"
  attr :additional_meta_tags, :list, default: []

  def live_meta_tags(assigns) do
    assigns = prepare_assigns(assigns)

    ~H"""
    <!-- Primary Meta Tags -->
    <meta charset="utf-8"/>
    <meta name="viewport" content={@viewport}/>
    <meta name="description" content={@meta_description} />
    <meta name="keywords" content={@meta_keywords} />
    <meta name="author" content={@author} />
    <meta name="language" content={@locale} />
    <meta name="robots" content={@robots} />
    <!-- Open Graph / Facebook -->
    <meta property="og:type" content={@og_type} />
    <meta property="og:title" content={@og_title} />
    <meta property="og:description" content={@og_description} />
    <%= if @og_image do %>
      <meta property="og:image" content={@og_image} />
    <% end %>
    <%= if @og_url do %>
      <meta property="og:url" content={@og_url} />
    <% end %>
    <!-- Twitter -->
    <meta name="twitter:card" content={@twitter_card} />
    <%= if @twitter_site do %>
      <meta name="twitter:site" content={@twitter_site} />
    <% end %>
    <meta name="twitter:title" content={@twitter_title} />
    <meta name="twitter:description" content={@twitter_description} />
    <%= if @twitter_image do %>
      <meta name="twitter:image" content={@twitter_image} />
    <% end %>

    <%= if @canonical_url do %>
      <link rel="canonical" href={@canonical_url} />
    <% end %>

    <%= for meta <- @additional_meta_tags do %>
       <%= render_meta_tag(meta) %>
    <% end %>
    """
  end

  @doc """
  Assigns meta tag values to the socket.
  """
  @spec assign_meta(Socket.t(), keyword()) :: Socket.t()
  def assign_meta(socket, opts) do
    Enum.reduce(opts, socket, fn {key, value}, acc ->
      Phoenix.Component.assign(acc, key, value)
    end)
  end

  defp prepare_assigns(assigns) do
    assigns
    |> prepare_og_tags()
    |> prepare_twitter_tags()
    |> maybe_add_defaults()
  end

  defp prepare_og_tags(assigns) do
    Map.merge(assigns, %{
      og_description: assigns.og_description || assigns.meta_description,
      og_title: assigns.og_title || assigns.meta_description
    })
  end

  defp prepare_twitter_tags(assigns) do
    Map.merge(assigns, %{
      twitter_title: assigns.twitter_title || assigns.og_title,
      twitter_description: assigns.twitter_description || assigns.og_description
    })
  end

  defp maybe_add_defaults(assigns) do
    Map.merge(assigns, %{
      og_site_name: assigns[:og_site_name] || "PHR-IO",
      meta_robots: assigns[:meta_robots] || "index,follow"
    })
  end

  defp render_meta_tag(%{name: name, content: content}) do
    # Use plain HTML since we're in a Phoenix Component
    assigns = %{name: name, content: content}

    ~H"""
    <meta name={@name} content={@content} />
    """
  end

  defp render_meta_tag(%{property: property, content: content}) do
    # Use plain HTML since we're in a Phoenix Component
    assigns = %{property: property, content: content}

    ~H"""
    <meta property={@property} content={@content} />
    """
  end
end
