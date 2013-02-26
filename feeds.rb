require 'mongo_hq_connector'

module Feeds
  module Decorator
    def initialize(decorated)
      @decorated = decorated
    end
  
    def method_missing(method, *args)
      args.empty? ? @decorated.send(method) : @decorated.send(method, args)
    end
  end
  
  class DB
    include Decorator
    
    def initialize(decorated = nil)
      @decorated = decorated

      database = MongoHqConnector.connection('friendly-rss')
      @collection = database['feeds']
    end
    
    %w(url xsl).each do |prp|
      define_method "get_#{prp}" do |name|
        f = named(name)
        
        return f.first[prp] if f.size > 0 and f.first[prp]
        return @decorated.send("get_#{prp}", name) if @decorated
        
        nil
      end
    end
    
    def all
      @collection.find(:url => /^https?:/)
    end
    
    def named(name)
      all.select {|f| f['name'] == name }
    end
    
    def create(params)
      raise "A feed named '#{params['name']}' already exists." if @collection.find('name' => params['name']).count > 0
      
      @collection.insert(
        name: params['name'], 
        url: params['url'], 
        xsl: params['xsl'], 
      )
    end
    
    def print(f)
      puts "#{ f['name'] }:"
      puts "  URL: #{ f['url'] }"
      puts "  XSL: #{ f['xsl'] || 'default' }"      
    end
  end
  
  class UrlPattern
    def initialize(url_template, xsl_url)
      @url_template = url_template
      @xsl_url = xsl_url
    end
    
    def get_xsl(name)
      @xsl_url
    end
    
    def get_url(name)
      @url_template.gsub('{NAME}', name)
    end
  end
end

