# THE README IS CURRENTLY A WIP SINCE THE COOKBOOK VERSION 3.0.0 is a major rewrite


## DESCRIPTION

Installs and configures Ceph, a distributed network storage and filesystem designed to provide excellent performance, reliability, and scalability.

The current version is focused towards deploying Monitors and OSD on Ubuntu.

For documentation on how to use this cookbook, refer to the [USAGE](#USAGE) section.

## REQUIREMENTS

### Chef

\>= 11.6.0

### Platform

Tested as working:

* Ubuntu Xenial (16.04)

### Cookbooks

## TEMPLATES

## USAGE

Ceph cluster design is beyond the scope of this README, please turn to the
public wiki, mailing lists, visit our IRC channel, or contact Inktank:

http://ceph.com/docs/master
http://ceph.com/resources/mailing-list-irc/
http://www.inktank.com/

This cookbook can be used to implement a chosen cluster design. Most of the configuration is retrieved from node attributes, which can be set by an environment or by a wrapper cookbook. A basic cluster configuration will need most of the following attributes:

* `node['ceph']['config']['global']['fsid']` - the cluster UUID
* `node['ceph']['config]'['global']['public network']` - a CIDR specification of the public network
* `node['ceph']['config]'['global']['cluster network']` - a CIDR specification of a separate cluster replication network
* `node['ceph']['config]'['global']['rgw dns name']` -  the main domain of the radosgw daemon

Most notably, the configuration does _NOT_ need to set the `mon_initial_members`, because the cookbook does a node search to find other mons in the same environment.


## ATTRIBUTES

### General

* `node['ceph']['search_environment']` - a custom Chef environment to search when looking for mon nodes. The cookbook defaults to searching the current environment
* `node['ceph']['branch']` - selects whether to install the stable, testing, or dev version of Ceph
* `node['ceph']['version']` - install a version of Ceph that is different than the cookbook default. If this is changed in a wrapper cookbook, some repository urls may also need to be replaced, and they are found in attributes/repo.rb. If the branch attribute is set to dev, this selects the gitbuilder branch to install
* `node['ceph']['extras_repo']` - whether to install the ceph extras repo. The tgt recipe requires this

* `node['ceph']['config']['fsid']` - the cluster UUID
* `node['ceph']['config']['global']['public network']` - a CIDR specification of the public network
* `node['ceph']['config']['global']['cluster network']` - a CIDR specification of a separate cluster replication network
* `node['ceph']['config']['config-sections']` - add to this hash to add extra config sections to the ceph.conf

* `node['ceph']['user_pools']` - an array of pool definitions, with attributes `name`, `pg_num` and `create_options` (optional), that are automatically created when a monitor is deployed

### Ceph MON

* `node['ceph']['config']['mon']` - a hash of settings to save in ceph.conf in the [mon] section, such as `'mon osd nearfull ratio' => '0.70'`

### Ceph OSD

* `node['ceph']['osd_devices']` - an array of OSD definitions for the current node
* `node['ceph']['config']['osd']` - a hash of settings to save in ceph.conf in the [osd] section, such as `'osd max backfills' => 2`
* `node['ceph']['config']['osd']['osd crush location']` - this attribute can be set on a per-node basis to maintain Crush map locations

### Ceph MDS

* `node['ceph']['config']['mds']` - a hash of settings to save in ceph.conf in the [mds] section, such as `'mds cache size' => '100000'`

### Ceph Rados Gateway

* `node['ceph']['radosgw']['api_fqdn']` - what vhost to configure in the web server
* `node['ceph']['radosgw']['admin_email']` - the admin email address to configure in the web server
* `node['ceph']['radosgw']['rgw_addr']` - the web server's bind address, such as *:80
* `node['ceph']['radosgw']['rgw_port']` - if set, connects to the radosgw fastcgi over this port instead of a unix socket
* `node['ceph']['radosgw']['webserver_companion']` - defaults to 'apache2', but it can be set to 'civetweb', or to false in order to leave it unconfigured
* `node['ceph']['radosgw']['path']` - where to save the s3gw.fcgi file
* `node['ceph']['config']['global']['rgw dns name']` -  the main domain of the radosgw daemon, to calculate the bucket name from a subdomain

## Resources/Providers

### ceph\_client

The ceph\_client LWRP provides an easy way to construct a Ceph client key. These keys are needed by anything that needs to talk to the Ceph cluster, including RadosGW, and RBD access.

#### Actions

- :add - creates a client key with the given parameters

#### Parameters

- :name - name attribute. The name of the client key to create. This is used to provide a default for the other parameters
- :caps - A hash of capabilities that should be granted to the client key. Defaults to `{ 'mon' => 'allow r', 'osd' => 'allow r' }`
- :as\_keyring - Whether the key should be saved in a keyring format or a simple secret key. Defaults to true, meaning it is saved as a keyring
- :keyname - The key name to register in Ceph. Defaults to `client.#{name}.#{hostname}`
- :filename - Where to save the key. Defaults to `/etc/ceph/ceph.client.#{name}.#{hostname}.keyring` if `as_keyring` and `/etc/ceph/ceph.client.#{name}.#{hostname}.secret` if not `as_keyring`
- :owner - Which owner should own the saved key file. Defaults to root
- :group - Which group should own the saved key file. Defaults to root
- :mode - What file mode should be applied. Defaults to '00640'

### ceph\_cephfs

[removed]

### ceph\_pool

The ceph\_pool LWRP provides an easy way to create and delete Ceph pools.

It assumes that connectivity to the cluster is setup and that admin credentials are available from default locations, e.g. /etc/ceph/ceph.client.admin.keyring.

#### Actions

- :add - creates a pool with the given number of placement groups
- :delete - deletes an existing pool

#### Parameters

- :name - the name of the pool to create or delete
- :pg_num - number of placement groups, when creating a new pool
- :create_options - arguments for pool creation (optional)
- :force - force the deletion of an exiting pool along with any data that is stored in it

## DEVELOPING

### Style Guide

This cookbook requires a style guide for all contributions. Travis will automatically verify that every Pull Request follows the style guide.

1. Install [ChefDK](http://downloads.chef.io/chef-dk/)
2. Activate ChefDK's copy of ruby: `eval "$(chef shell-init bash)"`
3. `bundle install`
4. `bundle exec rake style`

### Testing

This cookbook uses Test Kitchen to verify functionality. A Pull Request can't be merged if it causes any of the test configurations to fail.

1. Install [ChefDK](http://downloads.chef.io/chef-dk/)
2. Activate ChefDK's copy of ruby: `eval "$(chef shell-init bash)"`
3. `bundle install`
4. `bundle exec kitchen test aio-debian-74`
5. `bundle exec kitchen test aio-ubuntu-1204`
6. `bundle exec kitchen test aio-ubuntu-1404`

## LICENSE AND AUTHORS

* Author: Kyle Bader <kyle.bader@dreamhost.com>
* Author: Jan Klare <j.klare@cloudbau.de>

* Copyright 2013, DreamHost Web Hosting and Inktank Storage Inc.
* Copyright 2018, cloudbau GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
