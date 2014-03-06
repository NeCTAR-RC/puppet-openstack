class openstack::repos {

  $openstack_version = hiera('openstack_version')

  if $::rfc1918_gateway == 'true' {
    exec { 'cloudarchive-apt-key':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => "apt-key adv --keyserver pgp.mit.edu --keyserver-options http-proxy=\"${::http_proxy}\" --recv-keys EC4926EA",
      unless  => 'apt-key list | grep 4BD6EC30 >/dev/null 2>&1',
    }
  } else {
    apt::key { 'cloud-archive':
      key         => 'EC4926EA',
      key_server => 'pgp.mit.edu',
    }
  }

  apt::source { 'ubuntu-cloud-archive':
    location          => 'http://mirrors.melbourne.nectar.org.au/ubuntu-cloud/ubuntu',
    release           => "${lsbdistcodename}-updates/${openstack_version}",
    repos             => 'main',
    include_src       => false,
  }
}