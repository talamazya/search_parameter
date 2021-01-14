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
    test "changes page and extension in case of touching limit of page" do
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

    test "changes page, extension and topic in case of touching limit of page and extension" do
      next_search_params =
        %{
          search_type: :video,
          topic: "baseball",
          topic_extension: "howto",
          page: 3
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator2.next()

      assert next_search_params.search_type == :video
      assert next_search_params.topic == "golf"
      assert next_search_params.topic_extension == ""
      assert next_search_params.page == 1
    end

    test "changes page, extension, topic and search_type in case of touching limit of page, extension and topic" do
      next_search_params =
        %{
          search_type: :video,
          topic: "golf",
          topic_extension: "howto",
          page: 3
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator2.next()

      assert next_search_params.search_type == :channel
      assert next_search_params.topic == "baseball"
      assert next_search_params.topic_extension == ""
      assert next_search_params.page == 1
    end

    test "return first search in case end of all elements" do
      next_search_params =
        %{
          search_type: :channel,
          topic: "golf",
          topic_extension: "howto",
          page: 3
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator2.next()

      assert next_search_params.search_type == :video
      assert next_search_params.topic == "baseball"
      assert next_search_params.topic_extension == ""
      assert next_search_params.page == 1
    end

    test "return double next element in case call next two times" do
      next_search_params =
      %{
        search_type: :video,
        topic: "golf",
        topic_extension: "tips",
        page: 3
      }
        |> CurrentSearch.to_struct()
        |> SearchIterator2.next()
        |> SearchIterator2.next()

      assert next_search_params.search_type == :video
      assert next_search_params.topic == "golf"
      assert next_search_params.topic_extension == "news"
      assert next_search_params.page == 2
    end
  end
end
