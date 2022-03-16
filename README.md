# Hyrax::Hirmeos

`Hyrax::Hirmeos` is responsible for sending Hyrax works and file set unique identifiers to OPERAS/HIRMEOS so that Alt-metrics can be collected and displayed. Metrics are a traditional way to measure popularity of publications in the scientific community (i.e. how many times a paper has been cited). Information about the HIRMEOS project can be found here https://www.hirmeos.eu/

## Usage

_A detailed guide to setting up this Gem is incipient_.

## Installation

Add this line to your application's Gemfile:

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

```

## Tests

```bash
docker-compose exec -it web bundle exec rspec
```
