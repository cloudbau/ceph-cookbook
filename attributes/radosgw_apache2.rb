case node['platform_family']
when 'debian'
  # Note(JR): This is for Ubuntu 16.04 really
  default['ceph']['radosgw']['apache2']['packages'] = ['libapache2-mod-fcgid']
when 'suse'
  default['ceph']['radosgw']['apache2']['packages'] = ['apache2-mod_fastcgi', 'apache2-worker']
when 'rhel', 'fedora'
  default['ceph']['radosgw']['apache2']['packages'] = ['mod_fastcgi']
end
