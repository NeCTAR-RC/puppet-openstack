class openstack {

  # Set up repositories
  include ::openstack::repo

  include ::openstack::oslo_messaging

  # Packages
  class { 'openstack::package':
    require => Class['openstack::repo'],
  }

}
