defmodule Crowdsourcing.AccountsTest do
  use Crowdsourcing.DataCase

  alias Crowdsourcing.Accounts

  describe "users" do
    alias Crowdsourcing.Accounts.User

    test "list_users_by_characteristics/2 returns group users by characteristic without users" do
      characteristic = %{
        citizenship: [
          english: 0.25,
          french: 0.25,
          indian: 0.25,
          japanese: 0.25
        ],
        gender: %{male: 0.50, female: 0.50},
        age_concept: %{
          children: 0.40,
          adult: 0.60
        }
      }

      group = Accounts.list_users_by_characteristics(100, characteristics: characteristic)

      assert is_list(group)

      assert Kernel.length(group) ==
               length(characteristic.citizenship) * length(characteristic.gender) *
                 length(characteristic.age_concept)

      assert(
        List.first(group) ==
          %{
            age_concept: {:adult, 0.6},
            citizenship: {:english, 0.25},
            gender: {:female, 0.5},
            users: []
          }
      )
    end

    test "list_users_by_characteristics/2 returns group users by characteristic with users" do
      citizenship = ~w(english french indian japanese)
      gender = ~w(male female)

      for x <- 0..1000 do
        Crowdsourcing.Repo.insert(%Crowdsourcing.Accounts.User{
          birth_date: Faker.Date.date_of_birth(10..26),
          citizenship: Enum.random(citizenship),
          gender: Enum.random(gender),
          name: Faker.Person.name()
        })
      end

      group =
        Accounts.list_users_by_characteristics(
          100,
          characteristics = %{
            citizenship: [
              english: 0.25,
              french: 0.25,
              indian: 0.25,
              japanese: 0.25
            ],
            gender: %{male: 0.50, female: 0.50},
            age_concept: %{
              children: 0.40,
              adult: 0.60
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
  end
end
