require 'wikidata_ids_decorator/version'
require 'scraped'
require 'wikidata/fetcher'

class WikidataIdsDecorator < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      links = doc.css('#bodyContent a[href*="/wiki"][title]').reject { |a| a[:title].include? ':' }
      wdids = WikiData.ids_from_pages(language, links.map { |a| a[:title] }.uniq)
      links.each { |a| a[:wikidata] = wdids[a[:title]] }
    end.to_s
  end

  private

  def language
    'en'
  end
end
