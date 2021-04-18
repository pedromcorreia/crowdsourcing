defmodule Crowdsourcing.AccountsTest do
  use Crowdsourcing.DataCase

  describe "users" do
    alias Crowdsourcing.Accounts
    alias Crowdsourcing.Accounts.User

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

    test "list_users_by_characteristics/2 returns group users by characteristic without users" do
      characteristic = %{
        citizenship: [
          english: 25,
          french: 25,
          indian: 25,
          japanese: 25
        ],
        gender: %{male: 50, female: 50},
        age_concept: %{
          children: 40,
          adult: 60
        }
      }

      group = Accounts.list_users_by_characteristics(100, characteristic)

      assert is_list(group)

      assert Kernel.length(group) ==
               length(characteristic.citizenship) * map_size(characteristic.gender) *
                 map_size(characteristic.age_concept)

      assert(
        List.first(group) ==
          %{
            age_concept: {:adult, 60},
            citizenship: {:english, 25},
            gender: {:female, 50},
            users: []
          }
      )
    end

    test "list_users_by_characteristics/2 returns group users by characteristic with users" do
      for _x <- 1..1000, do: user_fixtures()

      group =
        Accounts.list_users_by_characteristics(
          100,
          %{
            citizenship: [
              english: 25,
              french: 25,
              indian: 25,
              japanese: 25
            ],
            gender: %{male: 50, female: 50},
            age_concept: %{
              children: 40,
              adult: 60
            }
          }
        )

      assert is_list(group)
      first_group_user = List.first(List.first(group).users)

      assert "english" == first_group_user.citizenship
      assert "female" == first_group_user.gender

      majority_date = Timex.shift(Date.utc_today(), years: -18)

      assert Date.compare(first_group_user.birth_date, majority_date) ==
               :lt
    end

    test "list_users_by_characteristics/2 raise FunctionClauseError with invalid params" do
      assert_raise FunctionClauseError, fn ->
        Accounts.list_users_by_characteristics(
          100,
          %{
            gender: %{male: 50, female: 50},
            age_concept: %{
              children: 40,
              adult: 60
            }
          }
        )
      end
    end
  end
end
