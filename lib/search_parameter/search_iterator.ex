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

  def next(%CurrentSearch{} = pre_search, opts) when is_list(opts) do
    %{
      search_type: next_element_option(@search_types, pre_search.search_type, opts, :search_type),
      topic: next_element_option(@topics, pre_search.topic, opts, :topic),
      topic_extension:
        next_element_option(@topic_extensions, pre_search.topic_extension, opts, :topic_extension),
      page: next_element_option(@pages, pre_search.page, opts, :page)
    }
    |> CurrentSearch.to_struct()
  end

  def next(params, opts),
    do: "not supported params #{inspect(params)} and options #{inspect(opts)}"

  def next_element_option(list, cur_ele, options, key) do
    if key in options do
      next_element(list, cur_ele)
    else
      cur_ele
    end
  end

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
