# encoding: UTF-8

require 'bundler/setup'
require 'aws-sdk-core'
require "awesome_print"

ow = Aws::OpsWorks::Client.new(region: 'us-east-1')

puts "Stacks:"

#What's up:
stack_response = ow.send('describe_stacks')
stack_response.each do |page|
  page.stacks.each do |stack|

    s = {:stack_id => stack.stack_id, :name => stack.name, :apps => [], :layers => []}

    app_response = ow.send('describe_apps', {:stack_id => stack.stack_id})
    app_response.each do |page|
      page.apps.each do |app|
        s[:apps].push :app_id => app.app_id, :name => app.name
      end
    end

    layer_response = ow.send('describe_layers', {:stack_id => stack.stack_id})
    layer_response.each do |page|
      page.layers.each do |layer|

        l = {:layer_id => layer.layer_id, :name => layer.name, :instances => [], :security_groups => layer.custom_security_group_ids.size}

        instance_response = ow.send('describe_instances', {:layer_id => layer.layer_id})
        instance_response.each do |page|
          page.instances.each do |instance|
            i = {:instance_id => instance.instance_id, :hostname => instance.hostname, :volumes => [], :security_groups => instance.security_group_ids.size}
            #puts instance

            volumne_response = ow.send('describe_volumes', {:instance_id => instance.instance_id})
            volumne_response.each do |page|
              page.volumes.each do |volume|
                i[:volumes].push :volume_id => volume.volume_id, :ec2_volume_id => volume.ec2_volume_id, :status => volume.status, :size => volume.size
              end
            end

            l[:instances].push i
          end
        end

        s[:layers].push l
      end
    end

    ap s

  end
end
