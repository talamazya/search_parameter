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

  def next(_previous_search) do
  end

  # ... whatever other functions you write
end
