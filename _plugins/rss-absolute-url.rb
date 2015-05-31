# Provides a Liquid filter to convert relative URLs to absolute ones in RSS feeds
# source: https://github.com/jessecrouch/jekyll-rss-absolute-urls

module Jekyll
  module RSSURLFilter
    def relative_urls_to_absolute(input)
      url = Jekyll.configuration({})['url']
      input.gsub('src="/', 'src="' + url + '/').gsub('href="/', 'href="' + url + '/')
    end
  end
end

Liquid::Template.register_filter(Jekyll::RSSURLFilter)
