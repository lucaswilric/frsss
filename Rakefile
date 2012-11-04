
require './feeds.rb'

# Connect to the MongoDB database
task :connect do
  @feeds = Feeds::DB.new()
  puts "Connected."
end

task :add, [:name, :url, :xsl_url] => :connect do |t, args|
  raise "Bad data!" if [nil, ''].include? args[:name]
  @feeds.create({ 'name' => args[:name], 'url' => args[:url], 'xsl' => args[:xsl_url] })
end

task :list => :connect do
  @feeds.all.each do |f| 
    @feeds.print(f)
  end
end
