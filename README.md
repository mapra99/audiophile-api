# Audiophile e-commerce API

This is the API for Audiophile, an e-commerce site. Even though it can be used independently, you can find the UI that consumes this API [here](https://github.com/mapra99/audiophile)

## Main features

This API contains the core functionality that a common e-commerce system would need:
- Products system with categories, toppings and stocks
- Super basic headless CMS to modify the content and details of each product
- An Admin namespace to create or edit all of the above
- OTP authentication via email
- Checkout flow with purchase carts, sign up/login, shipping address with geolocation and credit/debit card payment with Stripe
- Basic comms such as payment confirmation or failure emails
- Orders system to track purchase status after payment

## API Docs
You can find [the API documentation here](https://documenter.getpostman.com/view/10455715/UzQvsjmL)

## Technologies

- Ruby
- Rails
- PostgreSQL
- Redis
- Sidekiq
- RSpec
- Docker

### Vendors

- AWS S3 for assets storage
- AWS Location service for address geocoding
- SendGrid for Email Comms
- Stripe for payments
- Fly.io for hosting of demo app

## Installation Instructions

### Setup with Docker (recommended)

1. Install Docker Engine and docker-compose
2. Create a `tmp/` folder 1 level above the root directory of the project
  ```bash
    mkdir ../tmp
  ```
3. Create a .env file based on the existing .env.example file_
  ```bash
    cp .env.example .env
  ```
4. Follow the instructions on the .env file regarding the vendors variables that need  to be configured
5. Run docker-compose in development mode
  ```bash
  cd docker/development
  docker-compose up --build
  ```
6. Open a new terminal and setup the database
  ```bash
  docker-compose run web rails db:setup
  ```

#### Quickstart
Once everything is installed, this is the every day process to start up the environment:

1. Run docker-compose in development mode
  ```bash
  cd docker/development
  docker-compose up --build
  ```
2. Open a new terminal and run any possible migrations
  ```bash
  docker-compose run web rails db:migrate
  ```

### Traditional Setup

1. Install homebrew https://brew.sh/index_es
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install rbenv (Ruby versions manager) https://github.com/rbenv/rbenv
```
brew install rbenv ruby-build
```

3. Set up rbenv
```
rbenv init
```
Follow the printed instructions

4. Restart your terminal, and install ruby 
```
rbenv install 3.0.4
```

5. Install postgresql
```
brew install postgres
```

6. Start postgresql as a service
```
brew services start postgresql
```

7. Install ruby dependencies
```
bundle install
```

8. Create a .env file based on the existing .env.example file_
```bash
  cp .env.example .env
```

9. Follow the instructions on the .env file regarding the vendor variables that need to be configured

10. Set up the database
```
rails db:setup
```

11.  Install redis
```
brew install redis
```

12.  Start redis as a service
```
brew services start redis
```

13.  Start the rails server
```
rails server
```

#### Optional: Background Jobs
1. Run sidekiq on a separate terminal
```
bundle exec sidekiq
```

2. Go to http://localhost:3000/eng/sidekiq to monitor the jobs. Use the values defined in the `ADMIN_HTTP_USERNAME` and `ADMIN_HTTP_PASSWORD` env variables to login.

#### Quickstart

Once everything is installed, this is the every day process to start up the environment:

1. Start the postgres and redis services (this is probably that is done automatically when turning on the computer)
```
brew services start postgresql
brew services start redis
```

2. `cd` to the project folder.

3. Run any new db migration
```
rails db:migrate
```

4. Run the rails server
```
rails server
```
