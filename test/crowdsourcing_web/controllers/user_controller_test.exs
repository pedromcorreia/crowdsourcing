defmodule CrowdsourcingWeb.UserControllerTest do
  use CrowdsourcingWeb.ConnCase

  alias Crowdsourcing.Accounts
  alias Crowdsourcing.Accounts.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
