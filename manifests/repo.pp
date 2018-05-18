# Installs the opentack ubuntu cloud archive
class openstack::repo {

  $openstack_version = hiera('openstack_version')

  $supported = ['trusty-juno', 'trusty-kilo', 'trusty-liberty', 'trusty-mitaka',
                'xenial-newton', 'xenial-ocata', 'xenial-pike', 'xenial-queens']

  if "${::lsbdistcodename}-${openstack_version}" in $supported {

    if $::http_proxy and str2bool($::rfc1918_gateway) {
      $key_options = "http-proxy=${::http_proxy}"
    }
    else {
      $key_options = undef
    }

    apt::key { 'cloud-archive':
      id      => '391A9AA2147192839E9DB0315EDB1B62EC4926EA',
      server  => 'pgp.mit.edu',
      options => $key_options,
      notify  => Exec['apt_update'],
    }

    apt::source { 'ubuntu-cloud-archive':
      location    => 'http://mirrors.rc.nectar.org.au/ubuntu-cloud/ubuntu',
      release     => "${::lsbdistcodename}-updates/${openstack_version}",
      repos       => 'main',
    }
  }
}
