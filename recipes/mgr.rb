#
# Author:: Kyle Bader <kyle.bader@dreamhost.com>
# Author:: Dr. Jens Harbott <j.harbott@x-ion.de>
# Cookbook Name:: ceph
# Recipe:: mgr
#
# Copyright 2011, DreamHost Web Hosting
# Copyright 2018, x-ion GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'ceph'

cluster = 'ceph'

directory "/var/lib/ceph/mgr/#{cluster}-#{node['hostname']}" do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

mgr_user = "mgr.#{node['hostname']}"

ceph_user mgr_user do
  keyname mgr_user
  caps('osd' => 'allow *', 'mon' => 'allow profile mgr', 'mds' => 'allow *')
  key ceph_secret(mgr_user)
  action :create
end

ceph_client mgr_user do
  keyname mgr_user
  filename "/var/lib/ceph/mgr/#{cluster}-#{node['hostname']}/keyring"
  owner 'ceph'
  group 'ceph'
end

file "/var/lib/ceph/mgr/#{cluster}-#{node['hostname']}/done" do
  owner 'root'
  group 'root'
  mode 00644
end

service 'ceph_mgr' do
  service_name "ceph-mgr@#{node['hostname']}"
  action [:enable, :start]
  supports restart: true
end
