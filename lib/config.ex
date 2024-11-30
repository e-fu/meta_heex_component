defmodule MetaHeexComponent.Config do
  @moduledoc """
  Configuration handling for MetaHeexComponent.
  """

  @doc """
  Get configured defaults for meta tags.
  """
  def get_defaults do
    Application.get_env(:meta_heex_component, :defaults, %{})
  end
end
