defmodule CrowdsourcingWeb.UserView do
  use CrowdsourcingWeb, :view
  alias CrowdsourcingWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      gender: user.gender,
      birth_date: user.birth_date,
      citizenship: user.citizenship,
      name: user.name
    }
  end
end
