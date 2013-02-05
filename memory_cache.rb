module Cache
  class MemoryCache

    def initialize(timeout = 600)
      @cache = {}
      @timeout = timeout
    end

    def [](url)
      @cache[url]
    end

    def []=(url, data)
      @cache[url] = data.merge(updated_at: Time.now)
    end

    def valid?(url)
      @cache.has_key?(url) && @cache[url][:updated_at] > (Time.now - @timeout)
    end

  end
end
