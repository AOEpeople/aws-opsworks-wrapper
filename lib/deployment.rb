require 'aws-sdk-core'

module Aws
  module Deployment

    def run(opts)
      ow = Aws::OpsWorks::Client.new(region: 'us-east-1')
      response = ow.send('create_deployment', opts)
      return {:deployment_id => response[:deployment_id]}
    end

    def run_and_wait(opts)
      ow = Aws::OpsWorks::Client.new(region: 'us-east-1')
      deployment_id = run(opts)[:deployment_id]
      ap "Started deployment with ID: " + deployment_id
      last_state = 'running'
      while last_state == 'running'
        sleep 5
        response = ow.send('describe_deployments', {:deployment_ids => [deployment_id]})
        deployment_data = response[:deployments][0]
        last_state = deployment_data[:status]
      end
      return deployment_data
    end

  end
end
