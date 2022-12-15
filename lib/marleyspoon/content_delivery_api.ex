defmodule Marleyspoon.ContentDeliveryAPI do
  @moduledoc """
  Specifications for the Content API Behaviour.

  It can be set to your own client with:
      config :marleyspoon_recipes, :content_api_client, MyContentAPIClient

  Default client written in `Marleyspoon.ApiClient.ContentAPI`.
  """

  @doc """
  Callback to collect the content of all the recipes configured for master environment.
  """
  @callback get_entries() :: {:ok, map()} | {:error, String.t()}

  @doc """
  API used by adapters to fetch from the Content API.
  """
  def get_entries, do: api_client().get_entries()

  defp api_client do
    Application.fetch_env!(:marleyspoon, :content_api_client)
  end
end
