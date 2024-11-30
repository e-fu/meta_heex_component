defmodule PhoenixLiveMeta.Components.MetaTags do
  @moduledoc """
  Provides components for rendering meta tags in Phoenix applications.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.Socket

  @type meta_tag :: %{
          optional(:name) => String.t(),
          optional(:property) => String.t(),
          content: String.t()
        }

  # SEO Attributes
  attr :meta_description, :string, required: false, doc: "Primary meta description for SEO"
  attr :meta_keywords, :string, required: false, doc: "Keywords for SEO"
  attr :author, :string, required: false, doc: "Content author"
  attr :og_title, :string, required: false, doc: "Open Graph title"

  # Open Graph Attributes
  attr :og_description, :string, required: false, doc: "Open Graph description, falls back to meta_description"
  attr :og_type, :string, required: false, doc: "Open Graph type (e.g., 'website', 'article')"
  attr :og_image, :string, required: false, doc: "Open Graph image URL"
  attr :og_url, :string, required: false, doc: "Open Graph URL"

  # Twitter Card Attributes
  attr :twitter_card, :string, required: false, doc: "Twitter card type (e.g., 'summary_large_image', 'summary')"
  attr :twitter_site, :string, required: false, doc: "Twitter @username for the website"
  attr :twitter_title, :string, required: false, doc: "Twitter title, falls back to og_title"
  attr :twitter_description, :string, required: false, doc: "Twitter description, falls back to og_description"
  attr :twitter_image, :string, required: false, doc: "Twitter image URL"

  # Additional Attributes
  attr :canonical_url, :string, required: false, doc: "Canonical URL for SEO"
  attr :locale, :string, required: false, doc: "Content language (e.g., 'en', 'es')"

  attr :viewport, :string,
    required: false,
    doc: """
    Viewport meta tag content. Common values include:
    - "width=device-width, initial-scale=1"
    - "width=device-width, initial-scale=1, shrink-to-fit-no"
    - "width=device-width, initial-scale=1, maximum-scale=1"
    """

  attr :robots, :string, required: false, doc: "Robots meta tag content (e.g., 'index,follow', 'noindex,nofollow')"
  attr :additional_meta_tags, :list, default: [], doc: "List of additional meta tags to be rendered"

  def live_meta_tags(assigns) do
    assigns = prepare_assigns(assigns)

    ~H"""
    <!-- Primary Meta Tags -->
    <meta charset="utf-8"/>
    <%= if Map.get(assigns, :viewport) do %>
      <meta name="viewport" content={@viewport}/>
    <% end %>
    <%= if Map.get(assigns, :meta_description) do %>
      <meta name="description" content={@meta_description} />
    <% end %>
    <%= if Map.get(assigns, :meta_keywords) do %>
      <meta name="keywords" content={@meta_keywords} />
    <% end %>
    <%= if Map.get(assigns, :author) do %>
      <meta name="author" content={@author} />
    <% end %>
    <%= if Map.get(assigns, :locale) do %>
      <meta name="language" content={@locale} />
    <% end %>
    <%= if Map.get(assigns, :robots) do %>
      <meta name="robots" content={@robots} />
    <% end %>

    <!-- Open Graph / Facebook -->
    <%= if Map.get(assigns, :og_type) do %>
      <meta property="og:type" content={@og_type} />
    <% end %>
    <%= if Map.get(assigns, :og_title) do %>
      <meta property="og:title" content={@og_title} />
    <% end %>
    <%= if Map.get(assigns, :og_description) do %>
      <meta property="og:description" content={@og_description} />
    <% end %>
    <%= if Map.get(assigns, :og_image) do %>
      <meta property="og:image" content={@og_image} />
    <% end %>
    <%= if Map.get(assigns, :og_url) do %>
      <meta property="og:url" content={@og_url} />
    <% end %>

    <!-- Twitter -->
    <%= if Map.get(assigns, :twitter_card) do %>
      <meta name="twitter:card" content={@twitter_card} />
    <% end %>
    <%= if Map.get(assigns, :twitter_site) do %>
      <meta name="twitter:site" content={@twitter_site} />
    <% end %>
    <%= if Map.get(assigns, :twitter_title) do %>
      <meta name="twitter:title" content={@twitter_title} />
    <% end %>
    <%= if Map.get(assigns, :twitter_description) do %>
      <meta name="twitter:description" content={@twitter_description} />
    <% end %>
    <%= if Map.get(assigns, :twitter_image) do %>
      <meta name="twitter:image" content={@twitter_image} />
    <% end %>

    <%= if Map.get(assigns, :canonical_url) do %>
      <link rel="canonical" href={@canonical_url} />
    <% end %>

    <%= for meta <- Map.get(assigns, :additional_meta_tags, []) do %>
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

  defp prepare_assigns(%_{} = assigns), do: prepare_assigns(Map.from_struct(assigns))

  defp prepare_assigns(assigns) when is_map(assigns) do
    assigns
    |> Map.merge(PhoenixLiveMeta.Config.get_defaults())
    |> maybe_prepare_og_tags()
    |> maybe_prepare_twitter_tags()
  end

  defp maybe_prepare_og_tags(%{meta_description: description} = assigns) when not is_nil(description) do
    Map.merge(assigns, %{
      og_description: assigns[:og_description] || description,
      og_title: assigns[:og_title] || description
    })
  end

  defp maybe_prepare_og_tags(assigns), do: assigns

  defp maybe_prepare_twitter_tags(%{og_title: title, og_description: desc} = assigns)
       when not is_nil(title) or not is_nil(desc) do
    Map.merge(assigns, %{
      twitter_title: assigns[:twitter_title] || title,
      twitter_description: assigns[:twitter_description] || desc
    })
  end

  defp maybe_prepare_twitter_tags(assigns), do: assigns

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
