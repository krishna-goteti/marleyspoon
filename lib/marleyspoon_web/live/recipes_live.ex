defmodule MarleyspoonWeb.RecipesLive do
  use MarleyspoonWeb, :live_view

  @impl Phoenix.LiveView
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: MarleyspoonWeb.Endpoint.subscribe("live")

    {:ok, assign(socket, recipes: Marleyspoon.collect_recipes())}
  end

  @impl Phoenix.LiveView
  @spec handle_event(String.t(), map, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("recipe", %{"recipe_id" => recipe_id}, socket) do
    {:noreply, redirect(socket, to: "/show/#{recipe_id}")}
  end
end
