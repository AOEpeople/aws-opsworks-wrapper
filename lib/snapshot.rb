require 'aws-sdk-core'

module Aws
  module Snapshot

    def create(region, opts)
      ow = Aws::EC2::Client.new(region: region)
      response = ow.send('create_snapshot', opts)
      {:snapshot_id => response.snapshot_id}
    end

    def create_all(region, ids)



    end

  end
end