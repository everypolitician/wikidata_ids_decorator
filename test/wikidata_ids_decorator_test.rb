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

  describe 'English language links' do
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
      it 'follows the redirect and adds the correct wikidata item id' do
        decorator.body.must_include '<a href="/wiki/Vogons" class="mw-redirect" title="Vogons" wikidata="Q1076157">'
      end
    end

    describe 'Links outside of #bodyContent' do
      it 'leaves these links alone' do
        decorator.body.must_include '<a href="/wiki/Wikipedia:About" title="Wikipedia:About">About Wikipedia</a>'
      end
    end

    describe 'URLs containing a colon' do
      it 'leaves links not pointing to an article alone' do
        decorator.body.must_include '<a href="/wiki/Special:BookSources/0-330-26738-8" '\
                                    'title="Special:BookSources/0-330-26738-8">0-330-26738-8</a>'
      end
    end
  end

  describe 'Non English language links' do
    let(:url) { 'https://fr.wikipedia.org/wiki/La_Vie,_l%27Univers_et_le_Reste' }

    it 'adds the correct data-wikidata attribute to links' do
      decorator.body.must_include '<a href="/wiki/Plan%C3%A8te" title="Planète" wikidata="Q634">'
    end
  end

  describe 'Different Wikipedia links' do
    let(:url) { URI.encode 'https://el.wikipedia.org/wiki/Κατάλογος_Ελλήνων_βουλευτών_(Σεπτέμβριος_2015)' }

    it 'adds the correct data-wikidata attribute to remote links' do
      decorator.body.must_include '<a href="https://fr.wikipedia.org/wiki/Savvas_Anastasiadis" class="extiw" title="fr:Savvas Anastasiadis" wikidata="Q19204760">'
    end
  end
end
