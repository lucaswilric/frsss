require 'mongo_connector'

module Cache
  class NoDataError < Exception; end
  class MongoCache

    def initialize(timeout = 600)
      @timeout = timeout

      database = MongoConnector.connection('friendly-rss')
      @collection = database['cache']
    end

    def [](url)
      items = find_entries(url)

      return nil if items.count == 0

      item = items.first
      keys = item.keys

      keys.each do |k|
        item[k.to_sym] = item[k]
      end

      item
    end

    def []=(url, data)
      @collection.update({url: url}, data.merge(url: url, updated_at: Time.now), { upsert: true })
      data
    end

    def valid?(url)
      items = find_entries(url)
      items.count > 0
    end

    def find_entries(url)
      @collection.find(url: url, updated_at: {'$gt' => (Time.now - @timeout)})
    end
  end
end
