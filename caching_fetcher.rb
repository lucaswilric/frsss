
class CachingFetcher

  def initialize(cache, options = {})
    @cache = cache
    @debug = options[:debug] || false
  end

  def fetch(url)
    raise 'Need a URL, dammit!' unless url

    if @cache.valid? url
      body = @cache[url][:body]
    else
      puts "Fetching '#{url}'." if @debug
      response = Faraday.get(url)
      body = response.body

      @cache[url] = { body: body } if response.success?
    end

    body
  end
end
