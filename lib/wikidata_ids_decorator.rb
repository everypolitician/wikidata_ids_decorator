# frozen_string_literal: true
require 'wikidata_ids_decorator/version'
require 'scraped'
require 'wikidata/fetcher'

module WikidataIdsDecorator
  class Links < Scraped::Response::Decorator
    def body
      local_links.each { |llink| llink[:wikidata] = local_link_ids[llink[:title]] }
      remote_links.each { |rlink| rlink[:wikidata] = remote_link_ids[rlink[:title]] }
      working_body.to_s
    end

    private

    def working_body
      @working_body ||= Nokogiri::HTML(response.body)
    end

    def local_links
      working_body.css('#bodyContent a[href*="/wiki"][title]').reject { |link| link[:title].include? ':' }
    end

    def local_link_ids
      @local_link_ids ||= wikidata_ids(local_links.map { |a| a[:title] }.uniq)
    end

    def remote_links
      working_body.css('a[href*="wikipedia.org"][title].extiw')
    end

    def remote_links_by_lang
      remote_links.select { |link| link[:title].include? ':' }
                  .map { |link| link[:title].split ':', 2 }
                  .group_by(&:first)
                  .map { |lang, arts| [lang, arts.map(&:last)] }
                  .to_h
    end

    def remote_link_ids
      @remote_link_ids ||= remote_links_by_lang.flat_map do |lang, names|
        wikidata_ids(names, lang).map { |page, id| ["#{lang}:#{page}", id] }
      end.to_h
    end

    def wikidata_ids(links, language = default_language)
      WikiData.ids_from_pages(language, links)
    end

    def default_language
      URI.parse(url).host.split('.').first
    end
  end
end
