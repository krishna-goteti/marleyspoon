defmodule MarleyspoonWeb.RecipeLive do
  use MarleyspoonWeb, :live_view

  @impl Phoenix.LiveView
  @spec mount(map(), any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(%{"recipe_id" => recipe_id}, _session, socket) do
    if connected?(socket), do: MarleyspoonWeb.Endpoint.subscribe("live")

    {:ok, assign_recipe(socket, recipe_id)}
  end

  @impl Phoenix.LiveView
  @spec handle_event(String.t(), any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("recipes", _params, socket) do
    {:noreply, redirect(socket, to: "/")}
  end

  defp assign_recipe(socket, recipe_id) do
    [recipe] = Enum.filter(Marleyspoon.collect_recipes(), &(&1.recipe_id == recipe_id))

    assign(socket, recipe: recipe)
  end
end
