gems = ['rexml/document', 'xml/xslt', 'haml']
gems.each {|_gem| require _gem }

files = ['./feeds.rb', './caching_fetcher.rb', './memory_cache.rb', './db_cache.rb']
files.each {|f| require f }

def subdomain(host)
  host.split(/[.:]/)[0]
end

configure do
  url_template = "http://grabbit.lucasrichter.id.au/download_jobs/tagged/{NAME}/feed.rss"
  xsl_url = 'http://assets.lucasrichter.id.au/xsl/rss.xsl'
  set :feeds, Feeds::DB.new(Feeds::UrlPattern.new(url_template, xsl_url))
  set :fetcher, CachingFetcher.new(Cache::DbCache.new)
end

configure :production do
  require 'newrelic_rpm'
end

# Get the feed and perform an XSL transform on it, then present the result to the client.
get '/' do
  name = subdomain(request.host)
  
  rss = settings.fetcher.fetch(settings.feeds.get_url(name))
  xsl = settings.fetcher.fetch(settings.feeds.get_xsl(name))
  
  xslt = XML::XSLT.new()
  xslt.xml = REXML::Document.new rss.force_encoding('utf-8')
  xslt.xsl = REXML::Document.new xsl.force_encoding('utf-8')
  
  xslt.serve()
end

# Just get the feed and give it to the client.
get '/rss' do
  settings.fetcher.fetch(settings.feeds.get_url(subdomain(request.host)))
end
