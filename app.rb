gems = ['rexml/document', 'xml/xslt', 'haml', './feeds.rb']
gems.each {|_gem| require _gem }

def subdomain(host)
  host.split(/[.:]/)[0]
end

configure do
  url_template = "http://grabbit.lucasrichter.id.au/download_jobs/tagged/{NAME}/feed.rss"
  set :feeds, Feeds::DB.new(Feeds::UrlPattern.new(url_template))
end

# Get the feed and perform an XSL transform on it, then present the result to the client.
get '/' do
  rss = Faraday.get(settings.feeds.get_url(subdomain(request.host))).body
  xsl = Faraday.get('http://assets.lucasrichter.id.au/xsl/rss.xsl').body
  
  xslt = XML::XSLT.new()
  xslt.xml = REXML::Document.new rss.force_encoding('utf-8')
  xslt.xsl = REXML::Document.new xsl.force_encoding('utf-8')
  
  xslt.serve()
end

# Just get the feed and give it to the client.
get '/rss' do
  Faraday.get(settings.feeds.get_url(subdomain(request.host))).body
end

#get '/feeds' do
#  if settings.feeds.respond_to?(:all)
#    @feeds = settings.feeds.all
#    haml :index
#  else
#    "Nothing to see here."
#  end
#end
#
#get '/feeds/new' do
#  haml :feeds_new
#end
#
#post '/feeds/create' do
#  [:url, :name].each {|field| raise "Bad data!" if [nil, ''].include? params[field] }
#
#  settings.feeds.create(:name => params[:name], :url => params[:url])
#  
#  redirect to('/feeds')
#end