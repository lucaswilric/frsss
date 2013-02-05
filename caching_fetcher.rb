
class CachingFetcher

  def initialize(cache)
    @cache = cache
  end

  def fetch(url)
    raise 'Need a URL, dammit!' unless url

    unless @cache.valid?(url)
      @cache[url] = { body: Faraday.get(url).body }
    end

    @cache[url][:body]
  end
end
