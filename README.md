# Crowdsourcing

This application supports you to search some user by some characteristics.

The result of this response is a list with users.

## Decisions

#### 1. How to handle with different characteristics and different percentuals?

To get the limit of each group I need to do a function characteristic_size, the result is the limit of the query,
example is a group of adult: 60%, english: 25%, male: 50%, total 100 users.
So the multiplication of this four values will result in a value of 7.5 users, but in this case we use round to get the integer of this group, as 8 users.

## API

You can find the Postman Collection in https://www.getpostman.com/collections/92adab215ebcaa017792

## How to install?

You need to install docker https://docs.docker.com/get-docker/.

## How to run?

1. Run docker:
    docker-compose build

    if the deps are not compiled run:
    `docker-compose run --rm crowdsourcing mix deps.get`
    or
    `docker-compose run --rm crowdsourcing bash`
    `bash-5.0# mix deps.get`

2. Create the database

    `docker-compose run --rm crowdsourcing mix ecto.setup`

## Tests?

You can check the tests inside the tests/ folder

You can find the coverage with `open coverage/index.html` in your terminal.

    `docker-compose run --rm crowdsourcing mix test`
