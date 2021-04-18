defmodule CrowdsourcingWeb.UserController do
  use CrowdsourcingWeb, :controller

  alias Crowdsourcing.Accounts
  alias Crowdsourcing.Accounts.User

  action_fallback CrowdsourcingWeb.FallbackController

  def index(conn, %{"limit" => limit, "characteristcs" => characteristcs}) do
    users =
      Accounts.list_users_by_characteristics(parse_params(limit), parse_params(characteristcs))

    render(conn, "index.json", users: users)
  end

  defp parse_params(params) when is_map(params) do
    for {key, val} <- params, into: %{}, do: {String.to_atom(key), parse_params(val)}
  end

  defp parse_params(params) do
    case Integer.parse(params) do
      :error -> params
      {params, ""} -> params
    end
  end
end
