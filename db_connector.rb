require 'mongo'

class DbConnector
  @@database = nil

  def self.connection
    return @@database if @@database
    
    if ENV['MONGOHQ_URL']
      url = URI.parse(ENV['MONGOHQ_URL'])
      conn = Mongo::Connection.new(url.host, url.port)
      @@database = conn.db(url.path.gsub(/^\//, ''))
      @@database.authenticate(url.user, url.password)
      
      @@database
    else
      @@database = Mongo::Connection.new.db('friendly-rss')
    end
  end
end

