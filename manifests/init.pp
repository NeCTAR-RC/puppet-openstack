class openstack {

  # Set up repositories
  class { 'openstack::repo': }

  # Packages
  class { 'openstack::package':
    require => Class['openstack::repo'],
  }

}
