# encoding: UTF-8

require 'bundler/setup'
require "awesome_print"
require 'optparse'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

include Aws::Deployment
include Aws::Lockup

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: deploy.rb [options]"

  opts.on("-s", "--stack NAME", "Stack name") do |v|
    options[:stack] = v
  end
  opts.on("-a", "--app NAME", "App name") do |v|
    options[:app] = v
  end
  opts.on("-l", "--layer NAME", "Layer name, defaults to the app name if nothing is passed") do |v|
    options[:layer] = v
  end
  opts.on("-j", "--json JSON", "Customer Json which should be passed to the run") do |v|
    options[:json] = v
  end
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

exit 11 if options[:stack].nil?
exit 12 if options[:app].nil?
exit 13 if !ENV['AWS_ACCESS_KEY_ID'] || !ENV['AWS_SECRET_ACCESS_KEY']

options[:layer] = options[:app]

s = stack(options[:stack])
deployment_data = run_and_wait({
   :stack_id => s,
   :app_id => app(options[:app], s),
   :instance_ids => layer_instances(options[:layer], s),
   :command => {name: 'deploy'},
   :custom_json => options[:json]
})

ap deployment_data

exit 21 if deployment_data[:status] != 'successful'
