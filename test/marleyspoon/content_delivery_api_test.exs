defmodule Marleyspoon.ContentDeliveryAPITest do
  use ExUnit.Case

  import Tesla.Mock

  alias Marleyspoon.ContentDeliveryAPI

  describe "ContentDelivery" do
    test "get_entries/0 should handle failure cases" do
      mock(fn
        %{method: :get} ->
          {:error, %Tesla.Env{status: 404, body: "there was an error"}}
      end)

      assert ContentDeliveryAPI.get_entries() ==
               {:error, "received error with status 404 and body \"there was an error\""}
    end

    test "get_entries/0 should handle timeout/closed failures" do
      mock(fn
        %{method: :get} ->
          {:error, :timeout}
      end)

      assert ContentDeliveryAPI.get_entries() ==
               {:error, "received error :timeout"}
    end

    test "get_entries/0 should return expected results on " do
      mock(fn
        %{method: :get} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body:
               "{\"includes\":{\"Asset\":[{\"fields\":{\"file\":{\"contentType\":\"image/jpeg\",\"details\":{\"image\":{\"height\":680,\"width\":1020},\"size\":216391},\"fileName\":\"SKU1503_Hero_102__1_-6add52eb4eec83f785974ddeac3316b7.jpg\",\"url\":\"//images.ctfassets.net/kk2bw5ojx476/3TJp6aDAcMw6yMiE82Oy0K/2a4cde3c1c7e374166dcce1e900cb3c1/SKU1503_Hero_102__1_-6add52eb4eec83f785974ddeac3316b7.jpg\"},\"title\":\"SKU1503 Hero 102 1 -6add52eb4eec83f785974ddeac3316b7\"},\"metadata\":{\"tags\":[]},\"sys\":{\"createdAt\":\"2018-05-07T13:30:06.967Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"3TJp6aDAcMw6yMiE82Oy0K\",\"locale\":\"en-US\",\"revision\":1,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Asset\",\"updatedAt\":\"2018-05-07T13:30:06.967Z\"}}],\"Entry\":[{\"fields\":{\"name\":\"Mark Zucchiniberg \"},\"metadata\":{\"tags\":[]},\"sys\":{\"contentType\":{\"sys\":{\"id\":\"chef\",\"linkType\":\"ContentType\",\"type\":\"Link\"}},\"createdAt\":\"2018-05-07T13:28:25.324Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"1Z8SwWMmS8E84Iogk4E6ik\",\"locale\":\"en-US\",\"revision\":2,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Entry\",\"updatedAt\":\"2018-05-07T14:17:27.403Z\"}}]},\"items\":[{\"fields\":{\"calories\":345,\"chef\":{\"sys\":{\"id\":\"1Z8SwWMmS8E84Iogk4E6ik\",\"linkType\":\"Entry\",\"type\":\"Link\"}},\"description\":\"Warmer weather means the ushering in of grill season and this recipe completely celebrates the grill (or grill pan)! Squash and green beans are nicely charred then take a bath in a zesty cilantro-jalapeño dressing. After the steaks are perfectly seared, the same dressing does double duty as a tasty finishing sauce. A fresh radish salad tops it all off for crunch and a burst of color. Cook, relax, and enjoy!\",\"photo\":{\"sys\":{\"id\":\"3TJp6aDAcMw6yMiE82Oy0K\",\"linkType\":\"Asset\",\"type\":\"Link\"}},\"title\":\"Grilled Steak & Vegetables with Cilantro-Jalapeño Dressing\"},\"metadata\":{\"tags\":[]},\"sys\":{\"contentType\":{\"sys\":{\"id\":\"recipe\",\"linkType\":\"ContentType\",\"type\":\"Link\"}},\"createdAt\":\"2018-05-07T13:30:34.066Z\",\"environment\":{\"sys\":{\"id\":\"master\",\"linkType\":\"Environment\",\"type\":\"Link\"}},\"id\":\"2E8bc3VcJmA8OgmQsageas\",\"locale\":\"en-US\",\"revision\":3,\"space\":{\"sys\":{\"id\":\"kk2bw5ojx476\",\"linkType\":\"Space\",\"type\":\"Link\"}},\"type\":\"Entry\",\"updatedAt\":\"2018-05-07T13:37:01.760Z\"}}],\"limit\":100,\"skip\":0,\"sys\":{\"type\":\"Array\"},\"total\":1}"
           }}
      end)

      assert {:ok, response} = ContentDeliveryAPI.get_entries()

      assert response["total"] == 1
    end
  end
end
