class openstack::repo {

  $openstack_version = hiera('openstack_version')

  if $lsbdistcodename == 'precise' {

    $key_options = $::rfc1918_gateway ? { 
      'true'  => "http-proxy=http://${::http_proxy_server}:${::http_proxy_port}",
      default => false,
    }

    apt::key { 'cloud-archive':
      key         => 'EC4926EA',
      key_server  => 'pgp.mit.edu',
      key_options => $key_options,
    }

    apt::source { 'ubuntu-cloud-archive':
      location          => 'http://mirrors.melbourne.nectar.org.au/ubuntu-cloud/ubuntu',
      release           => "${lsbdistcodename}-updates/${openstack_version}",
      repos             => 'main',
      include_src       => false,
    }
  }
}
