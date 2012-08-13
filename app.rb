require 'rexml/document'
require 'xml/xslt'

get '/' do
  response = Faraday.get 'http://grabbit.lucasrichter.id.au/download_jobs/tagged/{TAG}/feed.rss'.gsub('{TAG}', request.host.split(/[.:]/)[0])
  
  rss = response.body
  
  response = Faraday.get 'http://assets.lucasrichter.id.au/xsl/rss.xsl'
  xsl = response.body
  
  xslt = XML::XSLT.new()
  xslt.xml = REXML::Document.new rss.force_encoding('utf-8')
  xslt.xsl = REXML::Document.new xsl.force_encoding('utf-8')
  
  xslt.serve()
end

