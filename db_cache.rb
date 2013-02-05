
require './db_connector.rb'

module Cache
  class DbCache

    def initialize(timeout = 600)
      @timeout = timeout

      database = DbConnector.connection
      @collection = database['cache']
    end

    def [](url)
      items = @collection.find(url: url, updated_at: {'$gt' => Time.now - @timeout})

      return nil unless items.count > 0

      item = items.first

      item.delete '_id'
      item.delete 'updated_at'

      keys = item.keys

      keys.each do |k|
        item[k.to_sym] = item[k]
      end
      
      item
    end

    def []=(url, data)
      if @collection.find_one(url: url)
        @collection.update({url: url}, data.merge(updated_at: Time.now))
      else
        @collection.insert(
          url: url,
          body: data[:body],
          updated_at: Time.now
        )
      end
    end

    def valid?(url)
      @collection.find(url: url, updated_at: {'$gt' => Time.now - @timeout}).count > 0
    end
  end
end
