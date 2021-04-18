defmodule CrowdsourcingWeb.UserControllerTest do
  use CrowdsourcingWeb.ConnCase

  alias Crowdsourcing.Accounts.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    def user_fixtures() do
      citizenship = ~w(english french indian japanese)
      gender = ~w(male female)

      Crowdsourcing.Repo.insert(%User{
        birth_date: Faker.Date.date_of_birth(10..26),
        citizenship: Enum.random(citizenship),
        gender: Enum.random(gender),
        name: Faker.Person.name()
      })
    end

    test "lists group users by characteristcs without any user", %{conn: conn} do
      characteristic_params = %{
        "citizenship" => [
          english: 25,
          french: 25,
          indian: 25,
          japanese: 25
        ],
        "gender" => %{"male" => 50, "female" => 50},
        "age_concept" => %{
          "children" => 40,
          "adult" => 60
        }
      }

      conn =
        get(
          conn,
          Routes.user_path(conn, :index, %{limit: 100, characteristcs: characteristic_params})
        )

      assert length(json_response(conn, 200)["data"]) == 16
      assert List.flatten(json_response(conn, 200)["data"]) == []
    end

    test "lists group users by characteristcs with any user", %{conn: conn} do
      for _x <- 1..1000, do: user_fixtures()

      characteristic_params = %{
        "citizenship" => [
          english: 25,
          french: 25,
          indian: 25,
          japanese: 25
        ],
        "gender" => %{"male" => 50, "female" => 50},
        "age_concept" => %{
          "children" => 40,
          "adult" => 60
        }
      }

      conn =
        get(
          conn,
          Routes.user_path(conn, :index, %{limit: 100, characteristcs: characteristic_params})
        )

      assert length(json_response(conn, 200)["data"]) == 16

      assert json_response(conn, 200)["data"] |> List.first() |> List.first() |> Map.keys() ==
               ~w(birth_date citizenship gender id name)
    end
  end
end
