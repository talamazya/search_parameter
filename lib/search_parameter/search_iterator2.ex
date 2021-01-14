defmodule SearchParameter.SearchIterator2 do
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

  def next(%CurrentSearch{} = pre_search) do
    with {page_state, :cont} <- search_params(pre_search, @pages, :page),
         {ext_state, :cont} <- search_params(page_state, @topic_extensions, :topic_extension),
         {topic_state, :cont} <- search_params(ext_state, @topics, :topic),
         {_, :cont} <- search_params(topic_state, @search_types, :search_type) do
      first()
    else
      {state, :stop} -> state
    end
  end

  def next(params), do: "not supported params #{inspect(params)}"

  defp search_params(state, list, key) do
    find_next_element(list, Map.get(state, key))
    |> case do
      nil -> {Map.put(state, key, List.first(list)), :cont}
      value -> {Map.put(state, key, value), :stop}
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
