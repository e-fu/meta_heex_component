defmodule PhoenixLiveMeta.Config do
  @moduledoc """
  Configuration handling for PhoenixLiveMeta.
  """

  @doc """
  Get configured defaults for meta tags.
  """
  def get_defaults do
    Application.get_env(:phoenix_live_meta, :defaults, %{})
  end
end
