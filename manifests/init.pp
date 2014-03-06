class openstack {

  anchor {'openstack::begin': }
  anchor {'openstack::end': }

  # Set up repositories
  class { 'openstack::repos': }

  # Packages
  class { 'openstack::packages': }

  # Ensure that we set up the repositories before trying to install
  # the packages
  Anchor['openstack::begin']
  -> Class['openstack::repos']
  -> Class['openstack::packages']
  -> Anchor['openstack::end']

}
