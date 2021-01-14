defmodule SearchParameter.SearchIteratorCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import SearchParameter.SearchIteratorCase
    end
  end

  setup _tags do
    {:ok, %{}}
  end
end
