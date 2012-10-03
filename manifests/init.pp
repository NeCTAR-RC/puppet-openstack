class openstack {

  @package { 'python-keystone':
    ensure => present,
  }

  @package { 'python-mysqldb':
    ensure => present,
  }

  package {'ubuntu-cloud-keyring':
    ensure => installed,
  }

  file {ubuntu-cloud-archive-repo:
    path    => '/etc/apt/sources.list.d/ubuntu-cloud-archive.list',
    source  => 'puppet:///modules/openstack/ubuntu-cloud-archive.list',
    notify  => Exec[apt-get-update],
    require => Package['ubuntu-cloud-keyring'],
  }
}
