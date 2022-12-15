defmodule MarleyspoonTest do
  use ExUnit.Case
  import Tesla.Mock

  describe "Marleyspoon" do
    test "get_entries/0 should be sucessfull when no results are found / any error received from ContentDeliveryAPI" do
      mock(fn
        %{method: :get} ->
          {:error, %Tesla.Env{status: 404, body: "there was an error"}}
      end)

      assert Marleyspoon.collect_recipes() == []
    end

    test "collect_recipes/0 should return expected results on success data fetch" do
      mock(fn
        %{method: :get} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body: sample_response()
           }}
      end)

      assert Marleyspoon.collect_recipes() == [
               %{
                 chef_name: "Jony Chives",
                 description:
                   "Crispy chicken skin, tender meat, and rich, tomatoey sauce form a winning trifecta of delicious in this one-pot braise. We spoon it over rice and peas to soak up every last drop of goodness, and serve a tangy arugula salad alongside for a vibrant boost of flavor and color. Dinner is served! Cook, relax, and enjoy!",
                 image:
                   "https://images.ctfassets.net/kk2bw5ojx476/5mFyTozvSoyE0Mqseoos86/fb88f4302cfd184492e548cde11a2555/SKU1479_Hero_077-71d8a07ff8e79abcb0e6c0ebf0f3b69c.jpg",
                 recipe_id: "437eO3ORCME46i02SeCW46",
                 tags: "gluten free, healthy",
                 title: "Crispy Chicken and Rice\twith Peas & Arugula Salad"
               }
             ]
    end
  end

  defp sample_response do
    "{\"includes\":{\"Asset\":[{\"fields\":{\"file\":{\"contentType\":\"image/jpeg\",\"details\":{\"image\":{\"height\":680,\"width\":1020},\"size\":230068},\"fileName\":\"SKU1479_Hero_077-71d8a07ff8e79abcb0e6c0ebf0f3b69c.jpg\",\"url\":\"//images.ctfassets.net/kk2bw5ojx476/5mFyTozvSoyE0Mqseoos86/fb88f4302cfd184492e548cde11a2555/SKU1479_Hero_077-71d8a07ff8e79abcb0e6c0ebf0f3b69c.jpg\"},\"title\":\"SKU1479 Hero 077-71d8a07ff8e79abcb0e6c0ebf0f3b69c\"},\"metadata\":{\"tags\":[]},\"sys\":{\"createdAt\":\"2018-05-07T13:31:45.501Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"5mFyTozvSoyE0Mqseoos86\",\"locale\":\"en-US\",\"revision\":1,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Asset\",\"updatedAt\":\"2018-05-07T13:31:45.501Z\"}}],\"Entry\":[{\"fields\":{\"name\":\"gluten free\"},\"metadata\":{\"tags\":[]},\"sys\":{\"contentType\":{\"sys\":{\"id\":\"tag\",\"linkType\":\"ContentType\",\"type\":\"Link\"}},\"createdAt\":\"2018-05-07T13:27:25.845Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"61Lgvo6rzUIgIGgcOAMgQ8\",\"locale\":\"en-US\",\"revision\":1,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Entry\",\"updatedAt\":\"2018-05-07T13:27:25.845Z\"}},{\"fields\":{\"name\":\"Jony Chives\"},\"metadata\":{\"tags\":[]},\"sys\":{\"contentType\":{\"sys\":{\"id\":\"chef\",\"linkType\":\"ContentType\",\"type\":\"Link\"}},\"createdAt\":\"2018-05-07T13:29:03.514Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"NysGB8obcaQWmq0aQ6qkC\",\"locale\":\"en-US\",\"revision\":2,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Entry\",\"updatedAt\":\"2018-05-07T14:19:02.570Z\"}},{\"fields\":{\"name\":\"healthy\"},\"metadata\":{\"tags\":[]},\"sys\":{\"contentType\":{\"sys\":{\"id\":\"tag\",\"linkType\":\"ContentType\",\"type\":\"Link\"}},\"createdAt\":\"2018-05-07T13:26:53.870Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"gUfhl28dfaeU6wcWSqs0q\",\"locale\":\"en-US\",\"revision\":2,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Entry\",\"updatedAt\":\"2018-05-07T13:27:08.774Z\"}}]},\"items\":[{\"fields\":{\"calories\":785,\"chef\":{\"sys\":{\"id\":\"NysGB8obcaQWmq0aQ6qkC\",\"linkType\":\"Entry\",\"type\":\"Link\"}},\"description\":\"Crispy chicken skin, tender meat, and rich, tomatoey sauce form a winning trifecta of delicious in this one-pot braise. We spoon it over rice and peas to soak up every last drop of goodness, and serve a tangy arugula salad alongside for a vibrant boost of flavor and color. Dinner is served! Cook, relax, and enjoy!\",\"photo\":{\"sys\":{\"id\":\"5mFyTozvSoyE0Mqseoos86\",\"linkType\":\"Asset\",\"type\":\"Link\"}},\"tags\":[{\"sys\":{\"id\":\"61Lgvo6rzUIgIGgcOAMgQ8\",\"linkType\":\"Entry\",\"type\":\"Link\"}},{\"sys\":{\"id\":\"gUfhl28dfaeU6wcWSqs0q\",\"linkType\":\"Entry\",\"type\":\"Link\"}}],\"title\":\"Crispy Chicken and Rice\\twith Peas & Arugula Salad\"},\"metadata\":{\"tags\":[]},\"sys\":{\"contentType\":{\"sys\":{\"id\":\"recipe\",\"linkType\":\"ContentType\",\"type\":\"Link\"}},\"createdAt\":\"2018-05-07T13:32:04.593Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"437eO3ORCME46i02SeCW46\",\"locale\":\"en-US\",\"revision\":3,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Entry\",\"updatedAt\":\"2018-05-07T13:36:41.741Z\"}}],\"limit\":100,\"skip\":0,\"sys\":{\"type\":\"Array\"},\"total\":1}"
  end
end
