Usage
=====

This build on top of the AWSRuby SDK: http://docs.aws.amazon.com/opsworks/latest/APIReference/Welcome.html

You should set the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY environment variables.

In order to run one of the scripts just trigger:

    bundle exec ruby <script> [options]
    bundle exec ruby deploy.rb -s "Ecommerce-Staging" -a "Magento"
    bundle exec ruby recipe.rb -s "Ecommerce-Production" -l "Magento" -r "project::_createbackup"

Scripts
=======

| Script                  | Description                                                                        |
|-------------------------|------------------------------------------------------------------------------------|
| `delete_snapshots.rb`   | deletes older snapshots than x days                                                |
| `describe.rb`           | shows all available stacks, apps, layers and related instances                     |
| `deploy.rb`             | triggers a plain deploy command for a app on all instances in the layer            |
| `list.rb`               | list snapshots for an account of for a specific volume id                          |
| `snapshot.rb`           | creates volume snapshots for a specific volume or all volumes of a layer           |
| `snapshot_root.rb`      | creates volume snapshots for a specific volume or all root volumes of a layer      |
| `recipe.rb`             | triggers a custom recipe                                                           |

Installation
=======

    $ bundle install --path .bundle
    or:
    $ bundle install --standalone

