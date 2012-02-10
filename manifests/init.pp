class openstack {

  file {'/etc/apt/sources.list.d/openstack-release-2011.3-lucid.list':
    ensure => file,
    source => 'puppet:///openstack/openstack-release-2011.3-lucid.list',
    notify => Exec[apt-get-update],
  }
  
  # Install openstack apt key when sources file changes
  exec { install-openstack-aptkey:
    command     => 'wget http://admin.rc.nectar.org.au/debian/openstack-apt.gpg -O - | apt-key add -',
    #command     => 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3D1B4472',
    subscribe   => File['/etc/apt/sources.list.d/openstack-release-2011.3-lucid.list'],
    path        => "/usr/bin:/usr/sbin:/bin",
    refreshonly => true,
    notify      => Exec[apt-get-update],
  }
  
}
