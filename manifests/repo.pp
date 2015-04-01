class openstack::repo {

  $openstack_version = hiera('openstack_version')

  # Icehouse is native to Trusty
  if $openstack_version != 'icehouse' {

    if $::http_proxy and $::rfc1918_gateway == 'true' {
      $key_options = "http-proxy=${::http_proxy}"
    }
    else {
      $key_options = false
    }

    apt::key { 'cloud-archive':
      key         => '391A9AA2147192839E9DB0315EDB1B62EC4926EA',
      key_server  => 'pgp.mit.edu',
      key_options => $key_options,
    }

    apt::source { 'ubuntu-cloud-archive':
      location          => 'http://mirrors.rc.nectar.org.au/ubuntu-cloud/ubuntu',
      release           => "${lsbdistcodename}-updates/${openstack_version}",
      repos             => 'main',
      include_src       => false,
    }
  }
}
