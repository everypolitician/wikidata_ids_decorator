# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wikidata_ids_decorator/version'

Gem::Specification.new do |spec|
  spec.name          = 'wikidata_ids_decorator'
  spec.version       = WikidataIdsDecorator::VERSION
  spec.authors       = ['EveryPolitician']
  spec.email         = ['team@everypolitician.org']

  spec.summary       = 'Scraped decorator to add Wikidata ids to Wikipedia links'
  spec.homepage      = 'https://github.com/everypolitician/wikidata_ids_decorator'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'scraped'
  spec.add_runtime_dependency 'wikidata-fetcher'
  spec.add_runtime_dependency 'pry'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-around'
  spec.add_development_dependency 'minitest-vcr'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'webmock'
end
