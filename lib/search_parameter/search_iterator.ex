defmodule SearchParameter.SearchIterator do
  alias SearchParameter.CurrentSearch

  @search_types [:video, :channel]
  @topics ["baseball", "golf"]
  @topic_extensions ["", "tips", "news", "howto"]
  @pages Enum.to_list(1..3)

  def first() do
    %{
      search_type: List.first(@search_types),
      topic: List.first(@topics),
      topic_extension: List.first(@topic_extensions),
      page: List.first(@pages)
    }
    |> CurrentSearch.to_struct()
  end

  def next(%CurrentSearch{} = previous_search) do
    %{
      search_type: next_element(@search_types, previous_search.search_type),
      topic: next_element(@topics, previous_search.topic),
      topic_extension: next_element(@topic_extensions, previous_search.topic_extension),
      page: next_element(@pages, previous_search.page)
    }
    |> CurrentSearch.to_struct()
  end

  def next(params), do: "not supported params #{inspect(params)}"

  def next_element(list, cur_ele) do
    find_next_element(list, cur_ele)
    |> case do
      nil -> List.first(list)
      next_ele -> next_ele
    end
  end

  # return nil in case not found or the last element
  # others, return next element
  defp find_next_element([], _), do: nil

  defp find_next_element([cur_ele | t], cur_ele), do: List.first(t)

  defp find_next_element([_ | t], cur_ele) do
    find_next_element(t, cur_ele)
  end
end
