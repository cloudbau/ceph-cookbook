name 'ceph'
maintainer 'Jan Klare'
maintainer_email 'j.klare@cloudbau.de'
license 'Apache 2.0'
description 'Installs/Configures the Ceph distributed filesystem'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.2'

depends	'apache2', '>= 1.1.12'
depends 'apt'
depends 'chef-vault'
depends 'yum', '>= 3.0'
depends 'yum-epel'
depends 'openstack-common'
depends 'compat_resource' # for Chef 13 custom resources in Chef 12

source_url 'https://github.com/cloudbau/ceph-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/cloudbau/ceph-cookbook/issues' if respond_to?(:issues_url)

gem 'netaddr'
