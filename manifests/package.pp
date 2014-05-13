class openstack::package {

  @package { 'python-keystone':
    ensure => present,
  }

  @package {'python-memcache':
    ensure => installed,
  }
}
