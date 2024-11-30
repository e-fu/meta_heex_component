defmodule PhoenixLiveMeta do
  @moduledoc """
  PhoenixLiveMeta provides dynamic meta tag management for Phoenix applications.

  ## Usage in LiveView

      def mount(_params, _session, socket) do
        {:ok,
         PhoenixLiveMeta.assign_meta(socket,
           page_title: "Dashboard",
           meta_description: "Your dashboard overview"
         )}
      end

  ## Usage in Controllers

      def index(conn, _params) do
        conn
        |> PhoenixLiveMeta.put_meta(
          meta_description: "Welcome to our homepage",
          og_title: "Homepage"
        )
        |> render("index.html")
      end
  """

  alias Phoenix.LiveView.Socket
  alias PhoenixLiveMeta.Components.MetaTags

  @doc """
  Renders meta tags component.
  """
  @spec live_meta_tags(map()) :: Phoenix.LiveView.Rendered.t()
  defdelegate live_meta_tags(assigns), to: MetaTags

  @doc """
  Assigns meta tag values to the socket.
  """
  @spec assign_meta(Socket.t(), keyword()) :: Socket.t()
  def assign_meta(socket, opts) do
    MetaTags.assign_meta(socket, opts)
  end

  @doc """
  Assigns meta values for controller-rendered templates.
  """
  @spec put_meta(Plug.Conn.t(), keyword()) :: Plug.Conn.t()
  def put_meta(conn, opts) do
    Enum.reduce(opts, conn, fn {key, value}, acc ->
      Plug.Conn.assign(acc, key, value)
    end)
  end
end
