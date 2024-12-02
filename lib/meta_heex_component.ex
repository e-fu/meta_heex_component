defmodule MetaHeexComponent do
  @moduledoc """
  MetaHeexComponent provides dynamic meta tag management for Phoenix applications.

  ## Usage in LiveView

      def mount(_params, _session, socket) do
        {:ok,
         MetaHeexComponent.assign_meta(socket,
           page_title: "Dashboard",
           meta_description: "Your dashboard overview"
         )}
      end

  ## Usage in Controllers

      def index(conn, _params) do
        conn
        |> MetaHeexComponent.put_meta(
          meta_description: "Welcome to our homepage",
          og_title: "Homepage"
        )
        |> render("index.html")
      end
  """

  alias MetaHeexComponent.Components.MetaTags
  alias Phoenix.LiveView.Socket

  @doc """
  Renders meta tags component.
  """
  @spec live_meta_tags(map()) :: Phoenix.LiveView.Rendered.t()
  defdelegate live_meta_tags(assigns), to: MetaTags

  @doc """
  Helper function to get all meta tags for rendering in templates.
  Merges defaults with explicit meta tags from assigns.
  """
  def get_meta_tags(assigns) do
    defaults = MetaHeexComponent.Config.get_defaults()
    meta_tags = assigns[:meta_tags] || %{}
    Map.merge(defaults, meta_tags)
  end

  @doc """
  Assigns meta tag values to the socket.
  Values provided here will override any defaults from config.
  """
  @spec assign_meta(Socket.t(), keyword()) :: Socket.t()
  def assign_meta(socket, opts) do
    # Convert opts to map and merge with existing meta_tags
    new_meta_tags =
      Map.get(socket.assigns, :meta_tags, %{})
      |> Map.merge(Map.new(opts))

    socket
    |> Phoenix.Component.assign(:meta_tags, new_meta_tags)
    |> Phoenix.Component.assign(opts)
  end

  @doc """
  Assigns meta values for controller-rendered templates.
  Values provided here will override any defaults from config.
  """
  @spec put_meta(Plug.Conn.t(), keyword()) :: Plug.Conn.t()
  def put_meta(conn, opts) do
    # Convert keyword list to map
    meta_map = Map.new(opts)

    # Get existing meta_tags or initialize empty map
    existing_meta = conn.assigns[:meta_tags] || %{}

    # Merge with existing meta tags
    new_meta_tags = Map.merge(existing_meta, meta_map)

    conn
    |> Plug.Conn.assign(:meta_tags, new_meta_tags)
    |> Plug.Conn.merge_assigns(meta_map)
  end
end
