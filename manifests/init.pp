class openstack {

  @package { 'python-keystone':
    ensure => present,
  }

  @package { 'python-mysqldb':
    ensure => present,
  }

  @package {'python-memcache':
    ensure => installed,
  }

  if $lsbdistcodename == 'precise' {

    package {'ubuntu-cloud-keyring':
      ensure  => installed,
      require => File['ubuntu-cloud-archive-repo'],
    }

    file { 'ubuntu-cloud-archive-repo':
      path    => '/etc/apt/sources.list.d/ubuntu-cloud-archive.list',
      source  => 'puppet:///modules/openstack/ubuntu-cloud-archive.list',
      notify  => Exec[apt-get-update],
    }
  }
}
