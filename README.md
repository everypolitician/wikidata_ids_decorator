# WikidataIdsDecorator

When scraping a page from Wikipedia, this [Scraped](https://github.com/everypolitician/scraped) decorator will attempt to look up the associated Wikidata item for each other Wikipedia page linked from within the page content. It adds a wikidata="Qxxx" attribute to each successfully resolved link.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wikidata_ids_decorator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wikidata_ids_decorator

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/wikidata_ids_decorator.
