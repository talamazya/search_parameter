defmodule SearchParameterWeb.PageController do
  use SearchParameterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
