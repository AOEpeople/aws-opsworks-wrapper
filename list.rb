# encoding: UTF-8

require 'bundler/setup'
require "awesome_print"
require 'optparse'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

ec2 = Aws::EC2::Client.new(region: 'eu-west-1')

volumeId = ENV['VOLUME_ID']


puts "----------------------------------------------------------------------------------------------------"
puts "----------------------Founded snapshots to the AWS given AWS Account--------------------------------"
puts "----------------------------------------------------------------------------------------------------"

ec2.describe_snapshots(owner_ids: ["self"]).snapshots.each do |snapshot|
  next if (!(volumeId.to_s.empty?) && snapshot.volume_id != volumeId)
  puts "Snapshot Id: #{snapshot.snapshot_id} Snapshot Description: #{snapshot.description}"
  puts "Snapshot Status: #{snapshot.state} Snapshot Start Time: #{snapshot.start_time}"
  puts "----------------------------------------------------------------------------------------------------"
end
