defmodule Marleyspoon do
  @moduledoc """
  Marleyspoon keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Marleyspoon.ContentDeliveryAPI

  def collect_recipes do
    with {:ok, %{"items" => items, "includes" => %{"Asset" => assets, "Entry" => entries}}} <-
           ContentDeliveryAPI.get_entries(),
         images <- collect_images(assets),
         {tags, chefs} <- collect_tags_and_chefs(entries) do
      process_recipes(items, tags, chefs, images)
    else
      _ -> []
    end
  end

  defp collect_images(assets) do
    assets
    |> Stream.filter(fn asset ->
      get_in(asset, ~w(fields file contentType)) == "image/jpeg"
    end)
    |> Stream.map(fn asset ->
      url = get_in(asset, ~w(fields file url))
      {get_in(asset, ~w(sys id)), Path.join("https:", url)}
    end)
    |> Map.new()
  end

  defp collect_tags_and_chefs(entries) do
    Enum.reduce(entries, {%{}, %{}}, fn entry, {tags, chefs} ->
      type = get_in(entry, ~w(sys contentType sys id))
      id = get_in(entry, ~w(sys id))
      name = get_in(entry, ~w(fields name))

      case type do
        "tag" -> {Map.put(tags, id, name), chefs}
        "chef" -> {tags, Map.put(chefs, id, name)}
      end
    end)
  end

  defp collect_tags(nil, _), do: "N/A"

  defp collect_tags(tags, tags_info) do
    tags
    |> Enum.map(fn %{"sys" => %{"id" => id}} ->
      tags_info[id]
    end)
    |> Enum.join(", ")
  end

  defp process_recipes(items, tags_info, chefs_info, images_info) do
    Enum.map(items, fn %{"fields" => fields} = item ->
      recipe_id = get_in(item, ~w(sys id))
      image_id = get_in(fields, ~w(photo sys id))
      chef_id = get_in(fields, ~w(chef sys id))

      tags = collect_tags(fields["tags"], tags_info)

      %{
        recipe_id: recipe_id,
        title: fields["title"],
        image: images_info[image_id],
        tags: tags,
        description: fields["description"],
        chef_name: chefs_info[chef_id] || "MarleySpoon's Special Recipe"
      }
    end)
  end
end
