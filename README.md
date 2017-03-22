# WikidataIdsDecorator

[Scraped](https://github.com/everypolitician/scraped) decorator which adds a `data-` attribute to Wikipedia links containing the Wikidata ID for the linked item, if relevant.

## Installation

Add these lines to your scraper's Gemfile:

```ruby
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }
gem 'wikidata_ids_decorator', github: 'everypolitician/wikidata_ids_decorator'
```

And then execute:

    $ bundle

## Usage

To use this in your scraper first `require` the library and then add it to your scraper class using the `decorator` macro.

``` ruby
require 'wikidata_ids_decorator'

class WikipediaPage < Scraped::HTML
  decorator WikidataIdsDecorator::Links

  field :wikidata_ids do
    noko.css('a/@wikidata').map(&:text)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/wikidata_ids_decorator.
