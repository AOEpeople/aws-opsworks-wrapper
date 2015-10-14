# encoding: UTF-8

require 'bundler/setup'
require "awesome_print"
require 'optparse'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

daysBackupIsHold = ENV['DAYS_BACKUP_HOLD_IN_DAYS'].to_i

if (daysBackupIsHold < 7)
  puts "Minimum 7 Days of Backups are hold."
  exit 1
end

oldTime = Time.now - (daysBackupIsHold * 24 * 3600)

ec2 = Aws::EC2::Client.new(region: 'eu-west-1')

puts "----------------------------------------------------------------------------------------------------"
puts "----------------------Founded snapshots to the AWS given AWS Account--------------------------------"
puts "----------------------------------------------------------------------------------------------------"

ec2.describe_snapshots(owner_ids: ["self"]).snapshots.each do |snapshot|
  next if !snapshot.description.include? "Autocreated"
  next if snapshot.start_time >= oldTime
  puts "Snapshot Id: #{snapshot.snapshot_id} Snapshot Description: #{snapshot.description}"
  puts "Snapshot Status: #{snapshot.state} Snapshot Start Time: #{snapshot.start_time}"
  ec2.delete_snapshot(snapshot_id: snapshot.snapshot_id)
  puts "----------------------------------------------------------------------------------------------------"
end
