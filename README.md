# Hyrax::Hirmeos

`Hyrax::Hirmeos` is responsible for sending Hyrax works and file set unique identifiers to OPERAS/HIRMEOS so that Alt-metrics can be collected and displayed. Metrics are a traditional way to measure popularity of publications in the scientific community (i.e. how many time a paper has been cited). Information about the HIRMEOS project can be found here https://www.hirmeos.eu/

## Usage

### Setting up HIRMEOS
1) Set up tokens service
https://github.com/hirmeos/tokens_api
The tokens API is used to authenticate the other hirmeos services when they talk to each other.
The service will request a token from the tokens API, and use the token to authenticate an
HTTP request to either the metrics-api or the identifier translation service.

2) Set up translator service
https://github.com/hirmeos/identifier_translation_service
The identifier translation service houses the various identifiers that belong to a work (uuids,
dois, landing page url, download links, etc). Once it is set up, each work that you want to track
metrics for must be registered in this service.
It is highly recommended that you register a canonical identifier for each type of identifier a
given work has. This is most important for the identifier that is queried when fetching metrics
from the metrics API.

3) Set up metrics API:
https://github.com/hirmeos/metrics-api
The metrics API stores metrics collected by the HIRMEOS services, and can be queried to fetch metrics
for a given work.

4) Configure drivers - either of the following can be used to collect views/downloads metrics:
https://github.com/hirmeos/access_logs_driver
https://github.com/hirmeos/google_analytics_driver
Once the drivers are configured, they should run, every day, collecting metrics.

5) Send metrics to metrics API.
Can be done using this tool:
https://github.com/hirmeos/metrics_submission
This is a simple tool for posting metrics, that have been collected, to the metrics API on a daily basis.

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

## Tests

```bash
docker-compose exec -it web bundle exec rspec
```
