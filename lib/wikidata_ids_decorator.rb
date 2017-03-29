require 'wikidata_ids_decorator/version'
require 'scraped'
require 'wikidata/fetcher'

module WikidataIdsDecorator
  class Links < Scraped::Response::Decorator
    def body
      Nokogiri::HTML(super).tap do |doc|
        links = doc.css('#bodyContent a[href*="/wiki"][title]').reject { |a| a[:title].include? ':' }
        wdids = wikidata_ids(links.map { |a| a[:title] }.uniq)
        links.each { |a| a[:wikidata] = wdids[a[:title]] }
      end.to_s
    end

    private

    def wikidata_ids(links)
      # TODO: Suppress 'Can't find Wikidata IDs for:' warnings
      # Issue: #7
      WikiData.ids_from_pages(language, links)
    end

    def language
      URI.parse(url).host.split('.').first
    end
  end
end
