defmodule SearchParameter.SearchIteratorTest do
  use SearchParameter.SearchIteratorCase

  alias SearchParameter.SearchIterator

  describe "type later" do
    test "riki here" do
      first_params = SearchIterator.first()

      assert first_params.search_type == :video
      assert first_params.topic == "baseball"
      assert first_params.topic_extension == ""
      assert first_params.page == 1
    end
  end
end
