defmodule SearchParameter.CurrentSearch do
  alias __MODULE__

  defstruct [
    :search_type,
    :topic,
    :topic_extension,
    :page
  ]

  def to_struct(current_search) do
    struct(CurrentSearch, current_search)
  end

  def to_map(current_search) do
    Map.from_struct(current_search)
  end
end
