
class CachingFetcher

  def initialize(cache)
    @cache = cache
  end

  def fetch(url)
    raise 'Need a URL, dammit!' unless url

    if @cache[url]
      body = @cache[url][:body]
    else
      body = Faraday.get(url).body
      @cache[url] = { body: body }
    end

    body
  end
end
