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

    apt::source { 'ubuntu-cloud-archive':
      location          => 'http://mirrors.melbourne.nectar.org.au/ubuntu-cloud/ubuntu',
      release           => 'precise-updates/folsom',
      repos             => 'main',
      required_packages => 'ubuntu-cloud-keyring',
      include_src       => false,
    }
  }
}
