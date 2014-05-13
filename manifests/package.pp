class openstack::package(
  $mysql_module = '0.9'
) {

  @package { 'python-keystone':
    ensure => present,
  }

  if ($mysql_module >= 2.2) {
    require mysql::bindings
    require mysql::bindings::python
  } else {
    include mysql::python
  }

  @package {'python-memcache':
    ensure => installed,
  }
}
