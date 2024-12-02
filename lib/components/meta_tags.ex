defmodule MetaHeexComponent.Components.MetaTags do
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
  attr :og_description, :string,
    required: false,
    doc: "Open Graph description, falls back to meta_description"

  attr :og_type, :string, required: false, doc: "Open Graph type (e.g., 'website', 'article')"
  attr :og_image, :string, required: false, doc: "Open Graph image URL"
  attr :og_url, :string, required: false, doc: "Open Graph URL"

  # Twitter Card Attributes
  attr :twitter_card, :string,
    required: false,
    doc: "Twitter card type (e.g., 'summary_large_image', 'summary')"

  attr :twitter_site, :string, required: false, doc: "Twitter @username for the website"
  attr :twitter_title, :string, required: false, doc: "Twitter title, falls back to og_title"

  attr :twitter_description, :string,
    required: false,
    doc: "Twitter description, falls back to og_description"

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

  attr :robots, :string,
    required: false,
    doc: "Robots meta tag content (e.g., 'index,follow', 'noindex,nofollow')"

  attr :additional_meta_tags, :list,
    default: [],
    doc: "List of additional meta tags to be rendered"

  def live_meta_tags(assigns) do
    assigns = prepare_assigns(assigns)

    ~H"""
    <!-- Primary Meta Tags -->
    <meta :if={assigns[:viewport]} name="viewport" content={assigns[:viewport]} />

    <meta :if={assigns[:meta_description]} name="description" content={assigns[:meta_description]} />
    <meta :if={assigns[:meta_keywords]} name="keywords" content={assigns[:meta_keywords]} />
    <meta :if={assigns[:author]} name="author" content={assigns[:author]} />
    <meta :if={assigns[:locale]} name="language" content={assigns[:locale]} />
    <meta :if={assigns[:robots]} name="robots" content={assigns[:robots]} />
    <meta :if={assigns[:application_name]} name="application-name" content={assigns[:application_name]} />

    <!-- Open Graph / Facebook -->
    <meta :if={assigns[:og_type]} property="og:type" content={assigns[:og_type]} />
    <meta :if={assigns[:og_title]} property="og:title" content={assigns[:og_title]} />
    <meta :if={assigns[:og_description]} property="og:description" content={assigns[:og_description]} />
    <meta :if={assigns[:og_image]} property="og:image" content={assigns[:og_image]} />
    <meta :if={assigns[:og_url]} property="og:url" content={assigns[:og_url]} />
    <meta :if={assigns[:og_site_name]} property="og:site_name" content={assigns[:og_site_name]} />
    <meta :if={assigns[:og_locale]} property="og:locale" content={assigns[:og_locale]} />

    <!-- Twitter -->
    <meta :if={assigns[:twitter_card]} name="twitter:card" content={assigns[:twitter_card]} />
    <meta :if={assigns[:twitter_site]} name="twitter:site" content={assigns[:twitter_site]} />
    <meta :if={assigns[:twitter_title]} name="twitter:title" content={assigns[:twitter_title]} />
    <meta :if={assigns[:twitter_description]} name="twitter:description" content={assigns[:twitter_description]} />
    <meta :if={assigns[:twitter_image]} name="twitter:image" content={assigns[:twitter_image]} />
    <meta :if={assigns[:twitter_image_alt]} name="twitter:image:alt" content={assigns[:twitter_image_alt]} />

    <!-- Accessibility / Misc -->
    <meta :if={assigns[:theme_color]} name="theme-color" content={assigns[:theme_color]} />
    <meta :if={assigns[:csp]} http-equiv="Content-Security-Policy" content={assigns[:csp]} />
    <link :if={assigns[:canonical_url]} rel="canonical" href={assigns[:canonical_url]} />
    <link :if={assigns[:manifest]} rel="manifest" href={assigns[:manifest]} />
    <link :if={assigns[:apple_touch_icon]} rel="apple-touch-icon" href={assigns[:apple_touch_icon]} />
    <link :if={assigns[:favicon]} rel="icon" href={assigns[:favicon]} />


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

  defp prepare_assigns(%_{} = assigns) do
    # Get meta_tags from assigns
    meta_tags = Map.get(assigns, :meta_tags, %{})
    struct_assigns = Map.from_struct(assigns)

    # Merge in precedence order: defaults <- struct assigns <- meta_tags
    MetaHeexComponent.Config.get_defaults()
    |> Map.merge(struct_assigns)
    |> Map.merge(meta_tags)
    |> maybe_prepare_og_tags()
    |> maybe_prepare_twitter_tags()
  end

  defp prepare_assigns(assigns) when is_map(assigns) do
    MetaHeexComponent.Config.get_defaults()
    |> Map.merge(assigns)
    |> maybe_prepare_og_tags()
    |> maybe_prepare_twitter_tags()
  end

  defp maybe_prepare_og_tags(assigns) do
    # Ensure og_description and og_title fall back to meta_description if not explicitly provided
    assigns
    |> Map.update(:og_description, assigns[:meta_description], fn existing ->
      existing || assigns[:meta_description]
    end)
    |> Map.update(:og_title, assigns[:meta_description], fn existing ->
      existing || assigns[:meta_description]
    end)
  end

  defp maybe_prepare_twitter_tags(assigns) do
    # Ensure twitter_title and twitter_description fall back to og_title and og_description if not explicitly provided
    assigns
    |> Map.update(:twitter_title, assigns[:og_title], fn existing ->
      existing || assigns[:og_title]
    end)
    |> Map.update(:twitter_description, assigns[:og_description], fn existing ->
      existing || assigns[:og_description]
    end)
  end

  defp render_meta_tag(%{name: name, content: content}) do
    assigns = %{name: name, content: content}

    ~H"""
    <meta name={@name} content={@content} />
    """
  end

  defp render_meta_tag(%{property: property, content: content}) do
    assigns = %{property: property, content: content}

    ~H"""
    <meta property={@property} content={@content} />
    """
  end
end
