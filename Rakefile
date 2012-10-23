
require './feeds.rb'

# Connect to the MongoDB database
task :connect do
  @feeds = Feeds::DB.new()
  puts "Connected."
end

task :add, [:name, :url] => :connect do |t, args|
  [:url, :name].each {|field| raise "Bad data!" if [nil, ''].include? args[field] }
  @feeds.create({ 'name' => args[:name], 'url' => args[:url] })
end

task :list => :connect do
  @feeds.all.each {|f| puts "#{ f['name'] }: #{ f['url'] }" }
end
