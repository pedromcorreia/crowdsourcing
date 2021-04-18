# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Crowdsourcing.Repo.insert!(%Crowdsourcing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
#

citizenship = ~w(english french indian japanese)
gender = ~w(male female)

for x <- 0..1000 do
  Crowdsourcing.Accounts.create_user(%{
    birth_date: Faker.Date.date_of_birth(10..26),
    citizenship: Enum.random(citizenship),
    gender: Enum.random(gender),
    name: Faker.Person.name()
  })
end
