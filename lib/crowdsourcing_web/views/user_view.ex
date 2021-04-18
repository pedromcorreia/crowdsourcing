defmodule CrowdsourcingWeb.UserView do
  use CrowdsourcingWeb, :view
  alias CrowdsourcingWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) when is_map(user) do
    Enum.map(user.users, fn x ->
      %{
        id: x.id,
        gender: x.gender,
        birth_date: x.birth_date,
        citizenship: x.citizenship,
        name: x.name
      }
    end)
  end
end
