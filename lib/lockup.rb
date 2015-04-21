require 'aws-sdk-core'


module Aws

  module Lockup

    def ow
      Aws::OpsWorks::Client.new(region: 'us-east-1')
    end

    def stack(name)
      s = nil
      response = ow.send('describe_stacks')
      response.each do |page|
        page.stacks.each do |stack|
          s = stack.stack_id if stack.name.eql? name
        end
      end
      throw :stack_not_found if s.nil?
      s
    end

    def app(name, stack)
      a = nil
      response = ow.send('describe_apps', :stack_id => stack)
      response.each do |page|
        page.apps.each do |app|
          a = app.app_id if app.name.eql? name
        end
      end
      throw :app_not_found if a.nil?
      a
    end

    def layer(name, stack)
      l = nil
      response = ow.send('describe_layers', :stack_id => stack)
      response.each do |page|
        page.layers.each do |layer|
          l = layer.layer_id if layer.name.eql? name
        end
      end
      throw :layer_not_found if l.nil?
      l
    end

    def layer_instances(name, stack)
      l = layer(name, stack)
      ids = []
      response = ow.send('describe_instances', {:layer_id => l})
      response.each do |page|
        page.instances.each do |instance|
          ids.push instance.instance_id
        end
      end
      ids
    end

    def layer_volumes(name, stack)
      instances = layer_instances(name, stack)
      ids = []
      instances.each do |instance|
        response = ow.send('describe_volumes', {:instance_id => instance})
        response.each do |page|
          page.volumes.each do |volume|
            ids.push volume.ec2_volume_id
          end
        end
      end
      ids
    end

  end
end
