# frozen_string_literal: true
require 'wikidata_ids_decorator/version'
require 'scraped'
require 'wikidata/fetcher'

module WikidataIdsDecorator
  class Links < Scraped::Response::Decorator
    def body
      Nokogiri::HTML(super).tap do |doc|
        local_links = doc.css('#bodyContent a[href*="/wiki"][title]')
                         .reject { |a| a[:title].include? ':' }
        wdids = wikidata_ids(local_links.map { |a| a[:title] }.uniq)
        local_links.each { |a| a[:wikidata] = wdids[a[:title]] }

        remote_links = doc.css('a[href*="wikipedia.org"][title].extiw')
        by_lang = remote_links.select { |a| a[:title].include? ':' }
                              .map { |a| a[:title].split ':', 2 }
                              .group_by(&:first)
                              .map { |lang, arts| [lang, arts.map(&:last)] }
                              .to_h
        mapped = by_lang.flat_map do |lang, names|
          wikidata_ids(names, lang).map { |page, id| ["#{lang}:#{page}", id] }
        end.to_h
        remote_links.each { |a| a[:wikidata] = mapped[a[:title]] }
      end.to_s
    end

    private

    def wikidata_ids(links, language = default_language)
      WikiData.ids_from_pages(language, links)
    end

    def default_language
      URI.parse(url).host.split('.').first
    end
  end
end
