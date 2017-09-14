class openstack {

  # Set up repositories
  include ::openstack::repo

  # Packages
  class { 'openstack::package':
    require => Class['openstack::repo'],
  }

}
