# Mini Rails

## Overview
This is a super simple re-implementation of Ruby on Rails for learning purpose. It supports the following features:

* Controllers
* Routing
* View rendering with erubis
* Simple ORM for SQLite
* Simple rack middleware
* Auto-loading

## Structure

### blog
A simple blog application following mostly the rails project structure. To run the server:

```
bundle install
bundle exec ruby db/migrations/mini_migration
bundle exec rackup -p 3001
```

Surf to ``localhost:3001``

### rulers
The actual re-implementation of Ruby on Rails followed by the excellent [Rebuilding Rails](https://rebuilding-rails.com/). However, some parts are different from the book.
