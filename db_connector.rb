require 'mongo'

class DbConnector
    def self.connect
      if ENV['MONGOHQ_URL']
        url = URI.parse(ENV['MONGOHQ_URL'])
        conn = Mongo::Connection.new(url.host, url.port)
        database = conn.db(url.path.gsub(/^\//, ''))
        database.authenticate(url.user, url.password)
      else
        Mongo::Connection.new.db('friendly-rss')
      end
    end
end

