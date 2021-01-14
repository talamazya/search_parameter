defmodule SearchParameter.SearchIterator2Test do
  use SearchParameter.SearchIteratorCase

  alias SearchParameter.SearchIterator2
  alias SearchParameter.CurrentSearch

  describe "first/0" do
    test "returns the first search params " do
      first_params = SearchIterator2.first()

      assert first_params.search_type == :video
      assert first_params.topic == "baseball"
      assert first_params.topic_extension == ""
      assert first_params.page == 1
    end
  end

  describe "next/1" do
    test "return next search params in happy case" do
      next_search_params =
        %{
          search_type: :video,
          topic: "golf",
          topic_extension: "tips",
          page: 3
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator2.next()

      assert next_search_params.search_type == :video
      assert next_search_params.topic == "golf"
      assert next_search_params.topic_extension == "news"
      assert next_search_params.page == 1
    end
  end
end
