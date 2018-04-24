# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'wikidata_ids_decorator'
require 'minitest/autorun'
require 'minitest/around/spec'
require 'vcr'
require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
end
