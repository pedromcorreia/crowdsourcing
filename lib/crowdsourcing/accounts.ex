defmodule Crowdsourcing.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Crowdsourcing.Repo

  alias Crowdsourcing.Accounts.User

  @majority_date Timex.shift(Date.utc_today(), years: -18)

  @doc """
  List users by characteristics.

  list_users_by_characteristics/2

  Required:
    total -> approximately size to list users;
    map -> with the characteristics as citizenship, gender, age_concept.

  ## Examples

  iex> list_users_by_characteristics(total,
        %{citizenship: citizenship, gender: gender, age_concept: age_concept}
      )
  )
  [
    %{
      age_concept: {:children, 0.4},
      citizenship: {:japanese, 0.25},
      gender: {:male, 0.5},
      users: [%User{}]
    }
  ]

  iex> list_users_by_characteristics(total,
        %{citizenship: citizenship, gender: gender, age_concept: age_concept}
      )
  )
  [
    %{
      age_concept: {:children, 0.4},
      citizenship: {:japanese, 0.25},
      gender: {:male, 0.5},
      users: []
    }
  ]
  """

  @spec list_users_by_characteristics(Integer.t(), %{
          citizenship: List.t(),
          gender: Map.t(),
          age_concept: Map.t()
        }) ::
          list(Map.t(Map.t(), Map.t(), Map.t(), Map.t(User.t())))
  def list_users_by_characteristics(
        size,
        characteristics = %{
          citizenship: _citizenship,
          gender: %{male: _male, female: _female},
          age_concept: %{
            children: _children,
            adult: _adult
          }
        }
      ) do
    Enum.map(characteristics.age_concept, fn age_concept ->
      Enum.map(characteristics.gender, fn gender ->
        Enum.map(characteristics.citizenship, fn citizenship ->
          %{
            citizenship: citizenship,
            gender: gender,
            age_concept: age_concept,
            users: list_users(size, citizenship, gender, age_concept)
          }
        end)
      end)
    end)
    |> List.flatten()
  end

  defp list_users(size, citizenship, gender, age_concept) do
    {citizenship, citizenship_percentage} = citizenship
    {gender, gender_percentage} = gender
    {age_concept, age_concept_percentage} = age_concept

    size
    |> characteristic_size(citizenship_percentage, gender_percentage, age_concept_percentage)
    |> list_users_by_characteristics_group(%{
      citizenship: to_string(citizenship),
      gender: to_string(gender),
      age_concept: to_string(age_concept)
    })
  end

  defp characteristic_size(size, citizenship, gender, age_concept) do
    round(size * citizenship * gender * age_concept)
  end

  defp list_users_by_characteristics_group(
         total,
         %{citizenship: citizenship, gender: gender, age_concept: "adult"}
       )
       when gender in ~w(male female) and is_integer(total) do
    from(u in User,
      where:
        u.citizenship == ^citizenship and u.gender == ^gender and
          u.birth_date <= ^@majority_date,
      select: u,
      limit: ^total
    )
    |> Repo.all()
  end

  defp list_users_by_characteristics_group(
         total,
         %{citizenship: citizenship, gender: gender, age_concept: "children"}
       )
       when gender in ~w(male female) and is_integer(total) do
    from(u in User,
      where:
        u.citizenship == ^citizenship and u.gender == ^gender and
          u.birth_date > ^@majority_date,
      select: u,
      limit: ^total
    )
    |> Repo.all()
  end
end
