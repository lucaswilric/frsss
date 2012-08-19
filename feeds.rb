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
    
    def initialize(decorated)
      @decorated = decorated
      @db = Mongo::Connection.new.db('friendly-rss')['feeds']
      @feeds = @db.find(:url => /^http/).to_a
    end
    
    def get_url(name)
      f = @feeds.select {|f| f['name'] == name }
      
      return f[0]['url'] if f.size > 0
      
      @decorated.get_url(name)
    end

    def all
      @feeds
    end
    
    def create(params)
      @db.insert(params)
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

