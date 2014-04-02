class openstack {

  # Set up repositories
  class { 'openstack::repos':
      stage => setup,
  }

  # Packages
  class { 'openstack::packages': }

}
