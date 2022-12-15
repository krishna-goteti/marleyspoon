defmodule Marleyspoon.Clients.ContentDeliveryAPI do
  @moduledoc """
  Client Implementation for the Content Delivery API

  Provides functionality to make HTTP calls to Content Delivery API
  """
  use Tesla

  alias Marleyspoon.ContentDeliveryAPI
  alias Tesla.Middleware

  @behaviour ContentDeliveryAPI

  plug Middleware.BaseUrl, Application.fetch_env!(:marleyspoon, :content_api_url)

  plug Middleware.JSON, engine: Jason

  plug Middleware.Retry,
    max_retries: 3,
    should_retry: fn
      {:ok, %{status: status}} when status in 400..500 -> true
      {:ok, _} -> false
      {:error, _} -> true
    end

  @impl ContentDeliveryAPI
  def get_entries do
    list_entries_url()
    |> get()
    |> case do
      {:ok, %Tesla.Env{body: body, status: 200}} ->
        {:ok, Jason.decode!(body)}

      {:error, %Tesla.Env{status: status, body: body}}
      when status in 400..500 ->
        {:error, "received error with status #{status} and body #{inspect(body)}"}

      {:error, error} ->
        {:error, "received error #{inspect(error)}"}
    end
  end

  defp list_entries_url do
    content_api_config = Application.get_env(:marleyspoon, :content_api_config)

    Path.join([
      "spaces",
      content_api_config[:space_id],
      "environments",
      content_api_config[:environment_id],
      "entries?access_token=#{content_api_config[:access_token]}&content_type=#{content_api_config[:content_type]}"
    ])
  end
end
