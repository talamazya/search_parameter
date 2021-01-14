defmodule SearchParameter.SearchIteratorTest do
  use SearchParameter.SearchIteratorCase

  alias SearchParameter.SearchIterator
  alias SearchParameter.CurrentSearch

  describe "first/0" do
    test "returns the first search params " do
      first_params = SearchIterator.first()

      assert first_params.search_type == :video
      assert first_params.topic == "baseball"
      assert first_params.topic_extension == ""
      assert first_params.page == 1
    end
  end

  describe "next_element/2" do
    test "returns first element in case end of list" do
      next_ele =
        ["", "tips", "news", "howto"]
        |> SearchIterator.next_element("howto")

      assert next_ele == ""
    end

    test "returns first element in case not found in list" do
      next_ele =
        ["", "tips", "news", "howto"]
        |> SearchIterator.next_element("not exist")

      assert next_ele == ""
    end

    test "return next element in happy case" do
      next_ele =
        ["", "tips", "news", "howto"]
        |> SearchIterator.next_element("tips")

      assert next_ele == "news"
    end
  end

  describe "next_element_option/4" do
    test "return next element in case key exists in options" do
      next_ele =
        ["", "tips", "news", "howto"]
        |> SearchIterator.next_element_option(
          "tips",
          [:topic_extension, :topic],
          :topic_extension
        )

      assert next_ele == "news"
    end

    test "return current element in case key does not exist in options" do
      next_ele =
        ["", "tips", "news", "howto"]
        |> SearchIterator.next_element_option(
          "tips",
          [:search_type, :topic],
          :topic_extension
        )

      assert next_ele == "tips"
    end
  end

  describe "next/1" do
    test "return next search params in happy case" do
      next_search_params =
        %{
          search_type: :video,
          topic: "baseball",
          topic_extension: "tips",
          page: 2
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator.next()

      assert next_search_params.search_type == :channel
      assert next_search_params.topic == "golf"
      assert next_search_params.topic_extension == "news"
      assert next_search_params.page == 3
    end

    test "return next search params in case some elements are in end of list" do
      next_search_params =
        %{
          search_type: :video,
          topic: "golf",
          topic_extension: "howto",
          page: 2
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator.next()

      assert next_search_params.search_type == :channel
      assert next_search_params.topic == "baseball"
      assert next_search_params.topic_extension == ""
      assert next_search_params.page == 3
    end

    test "return next search params in case some elements are not found" do
      next_search_params =
        %{
          search_type: :video,
          topic: "not found",
          topic_extension: "",
          page: 4
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator.next()

      assert next_search_params.search_type == :channel
      assert next_search_params.topic == "baseball"
      assert next_search_params.topic_extension == "tips"
      assert next_search_params.page == 1
    end
  end

  describe "next/2" do
    test "return next search params in case some options in element " do
      next_search_params =
        %{
          search_type: :video,
          topic: "baseball",
          topic_extension: "tips",
          page: 2
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator.next([:search_type, :topic_extension])

      assert next_search_params.search_type == :channel
      assert next_search_params.topic == "baseball"
      assert next_search_params.topic_extension == "news"
      assert next_search_params.page == 2
    end

    test "return current search params in case empty option " do
      next_search_params =
        %{
          search_type: :video,
          topic: "baseball",
          topic_extension: "tips",
          page: 2
        }
        |> CurrentSearch.to_struct()
        |> SearchIterator.next([])

      assert next_search_params.search_type == :video
      assert next_search_params.topic == "baseball"
      assert next_search_params.topic_extension == "tips"
      assert next_search_params.page == 2
    end
  end
end
