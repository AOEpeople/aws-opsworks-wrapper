# encoding: UTF-8

require 'bundler/setup'
require "awesome_print"
require 'optparse'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

include Aws::Snapshot
include Aws::Lockup

options = {:region => 'eu-west-1'}
OptionParser.new do |opts|
  opts.banner = "Usage: snapshot.rb (-v ID | -s NAME -l NAME)"

  opts.on("-r", "--region NAME", "Region NAME") do |v|
    options[:region] = v
  end
  opts.on("-s", "--stack NAME", "Stack name") do |v|
    options[:stack] = v
  end
  opts.on("-l", "--layer NAME", "Layer name, if passed all instance volumes will get a snapshot") do |v|
    options[:layer] = v
  end

  opts.on("-d", "--description TEXT", "Snapshot") do |v|
    options[:description] = v
  end
  opts.on("-v", "--volume ID", "Volume ID") do |v|
    options[:id] = v
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

exit 1 if options[:id].nil? && !options[:layer]
exit 2 if options[:layer] && !options[:stack]
exit 3 if !ENV['AWS_ACCESS_KEY_ID'] || !ENV['AWS_SECRET_ACCESS_KEY']

options[:description] = "Autocreated for Stack #{options[:stack]}, Layer: #{options[:layer]}" if options[:layer] && !options[:description]
options[:description] = "Autocreated" unless options[:layer] || options[:description]

if options[:layer]
  rootIds = layer_root_volumes(options[:layer], stack(options[:stack]))
  ap rootIds.each { |id|
    create(options[:region], { :volume_id => id, :description  => "#{options[:description]} Root Volume" })
  }
else
  ap create(options[:region], { :volume_id => options[:id], :description  => "#{options[:description]} Root Volume"})
end
