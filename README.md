# Hyrax::Hirmeos
Short description and motivation.

## Installation

```ruby
gem 'hyrax-hirmeos'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install hyrax-hirmeos
```

When you have installed the gem, or set it up locally, you will need to run:

```bash
bundle exec rails g hyrax-hirmeos:install
```

## Development

When cloning, you will need to bring in the Hyrax submodule by:

```bash
cd spec/internal_test_hyrax;
git submodule init && git submodule update
```

Then you can build the application from the root folder (`cd ../../`):

```bash
docker-compose up --build web
```

You may have issues with Action Cable trying to access redis via localhost:

```bash
# /spec/internal_test_hyrax/config/cable.yml
development:
  adapter: redis
  url: redis://redis:6379

# Or
development:
	adapter: async
```

The first time you run `docker-compose up web` you'll need to run the migrations to install Hyrax. You can do this manually, or you can change the `docker-compose.yml` file web service command:

```yaml
# Uncomment the first line and comment the second line so that the `db:create` and `db:migrate` will be run

# command: bash -c "rm -f spec/internal_test_hyrax/tmp/pids/server.pid && bundle exec rails db:create && bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0"
command: bash -c "rm -f spec/internal_test_hyrax/tmp/pids/server.pid && bundle install && bundle exec rails server -b 0.0.0.0"
```

It's fine to leave it like that, however the container boot will just take longer than it overwise would.

### Debugging

In order to get access to `byebug` you will need to start the web container with a different command:

```bash
docker-compose up -d web; docker attach hyrax-hirmeos_web_1
```

Now when you add `byebug` to a ruby file you will be able to interact with the prompt.

### Users

You will need to create a new user before you can login. Admin users are found within the `spec/internal_test_hyrax/config/role_map.yml`. Login to the rails console and create a user:

```ruby
User.create(email: 'admin@example.com', password: 'test1234')
```

### Creating Works

If you find you're unable to cannot create works, your admin set might be missing:

```ruby
bundle exec rails app:hyrax:default_collection_types:create;
bundle exec rails app:hyrax:default_admin_set:create
```

## Tests

```bash
docker-compose exec -it web bundle exec rspec
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
