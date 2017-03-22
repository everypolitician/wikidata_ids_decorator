require 'test_helper'

describe WikidataIdsDecorator do
  it 'has a version number' do
    ::WikidataIdsDecorator::VERSION.wont_be_nil
  end

  describe 'Wikipedia page with links' do
    it 'adds a data-wikidata attribute to links' do
      body = <<-HTML
<div id="bodyContent">
  <a href="https://en.wikipedia.org/wiki/Douglas_Adams" title="Douglas Adams">Douglas Adams</a>
</div>
      HTML
      response = Scraped::Response.new(body: body, url: 'https://en.wikipedia.org/wiki/Douglas_Adams_(disambiguation)')
      decorator = WikidataIdsDecorator.new(response: response)
      decorator.body.must_include '<a href="https://en.wikipedia.org/wiki/Douglas_Adams" title="Douglas Adams"' \
        ' wikidata="Q42">Douglas Adams</a>'
    end
  end
end
