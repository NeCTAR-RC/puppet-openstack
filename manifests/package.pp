class openstack::package {

  @package { 'python-keystone':
    ensure => present,
  }

  ensure_packages(['python-memcache'])
  
#  @package {'python-memcache':
#    ensure => installed,
#  }
}
