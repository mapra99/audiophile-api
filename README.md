# Audiophile e-commerce API

This is the API for Audiophile, an e-commerce site.
The project is in progress, it's not stable yet. Give it a star and subscribe if you like it so far :) 

## API Docs
You can find [the API documentation here](https://documenter.getpostman.com/view/10455715/UzQvsjmL)

## ERD
![]("./docs/../../docs/erd.png)

## Installation Instructions

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
rbenv install 3.0.0
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

8. Run rails db migrations
```
rails db:migrate
```

9. Install redis
```
brew install redis
```

10. Start redis as a service
```
brew services start redis
```

11. Set up the ENV file
- Create a file called `.env` on the project root
- Set the env variables (ask a teammate for them)

12. Start the rails server
```
rails server
```

### Optional: Background Jobs
1. Run sidekiq on a separate terminal
```
bundle exec sidekiq
```

2. Go to http://localhost:3000/eng/sidekiq to monitor the jobs

## Quickstart

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

