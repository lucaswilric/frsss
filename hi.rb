['rubygems','sinatra'].each {|_gem| require _gem }

get '/' do
  "Hi!"
end

