class openstack {

  # Set up repositories
  class { 'openstack::repos':
      stage => first,
  }

  # Packages
  class { 'openstack::packages': }

}
