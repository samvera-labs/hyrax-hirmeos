# Hyrax::Hirmeos

`Hyrax::Hirmeos` is responsible for sending Hyrax works and file set unique identifiers to OPERAS/HIRMEOS so that Alt-metrics can be collected and displayed. Metrics are a traditional way to measure popularity of publications in the scientific community (i.e. how many times a paper has been cited). Information about the HIRMEOS project can be found here https://www.hirmeos.eu/

## Install into your Hyrax/Hyku installation

Add the following to your Gemfile:

```ruby
gem 'hyrax-hirmeos', git: 'https://github.com/ubiquitypress/hyrax-hirmeos', branch: 'main'
```

And then execute:

```bash
bundle install
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
docker-compose up --build
```

## Testing

```bash
docker-compose exec web bundle exec rspec
```
