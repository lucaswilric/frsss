require 'mongo'

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
      
      if ENV['MONGOHQ_URL']
        url = URI.parse(ENV['MONGOHQ_URL'])
        conn = Mongo::Connection.new(url.host, url.port)
        database = conn.db(url.path.gsub(/^\//, ''))
        database.authenticate(url.user, url.password)
        @collection = database['feeds']
      else
        @collection = Mongo::Connection.new.db('friendly-rss')['feeds']
      end
      
    end
    
    def get_url(name)
      f = all.select {|f| f['name'] == name }
      
      return f.first['url'] if f.size > 0
      
      @decorated.get_url(name) if @decorated
    end

    def all
      @collection.find(:url => /^https?:/)
    end
    
    def create(params)
      raise "A feed named '#{params['name']}' already exists." if @collection.find('name' => params['name']).to_a
      
      @collection.insert(params)
    end
  end
  
  class UrlPattern
    def initialize(template)
      @template = template
    end
  
    def get_url(name)
      @template.gsub('{NAME}', name)
    end
  end
end

