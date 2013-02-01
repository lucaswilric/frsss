
class CachingFetcher

  def initialize
    @cache = {}
  end

  def fetch(url)
    raise 'Need a URL, dammit!' unless url
 
    unless valid?(url)
      @cache[url] = { body: Faraday.get(url).body, updated_at: Time.now }
    end

    @cache[url][:body]
  end

  private

  def valid?(url)
    @cache.has_key?(url) && @cache[url][:updated_at] > (Time.now - 600)
  end
end
