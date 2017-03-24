require 'test_helper'

describe WikidataIdsDecorator do
  describe 'gem' do
    it 'has a version number' do
      ::WikidataIdsDecorator::VERSION.wont_be_nil
    end
  end
end

describe WikidataIdsDecorator::Links do
  around { |test| VCR.use_cassette(File.basename(url), &test) }
  let(:response) { Scraped::Request.new(url: url).response }
  let(:decorator) { WikidataIdsDecorator::Links.new(response: response) }
  let(:url) { 'https://en.wikipedia.org/wiki/Life,_the_Universe_and_Everything' }

  describe 'Wikipedia page with links' do
    it 'adds a data-wikidata attribute to links' do
      decorator.body.must_include '<a href="/wiki/Douglas_Adams" title="Douglas Adams" wikidata="Q42">'
    end
  end

  describe 'Anchored links' do
    it 'adds a data-wikidata attribute to anchored links' do
      decorator.body.must_include '<a href="/wiki/OCLC#Identifiers_and_linked_data" title="OCLC" wikidata="Q190593">'
    end

    it 'does not add a data-wikidata attribute to anchored links pointing to a place within the same page' do
      decorator.body.must_include '<a href="#Plot_summary">'
    end
  end

  describe 'Redirect links' do
    it 'it follows the redirect and adds the correct wikidata item id' do
      decorator.body.must_include '<a href="/wiki/Vogons" class="mw-redirect" title="Vogons" wikidata="Q1076157">'
    end
  end

  describe 'Links outside of #bodyContent' do
    it 'should leave these links alone' do
      decorator.body.must_include '<a href="/wiki/Wikipedia:About" title="Wikipedia:About">About Wikipedia</a>'
    end
  end
end
