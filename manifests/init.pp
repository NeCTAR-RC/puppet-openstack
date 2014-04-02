class openstack {

  # Set up repositories
  class { 'openstack::repo':
      stage => setup,
  }

  # Packages
  class { 'openstack::package': }

}
