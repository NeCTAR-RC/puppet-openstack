# Installs the opentack ubuntu cloud archive
class openstack::repo::ubuntu(
  $mirror_url = 'http://mirrors.rc.nectar.org.au/ubuntu-cloud/ubuntu',
) {

  $openstack_version = hiera('openstack_version')

  $supported = ['trusty-juno', 'trusty-kilo', 'trusty-liberty', 'trusty-mitaka',
                'xenial-newton', 'xenial-ocata', 'xenial-pike', 'xenial-queens',
                'bionic-rocky', 'bionic-stein', 'bionic-train', 'bionic-ussuri',
                'focal-victoria']

  if "${::lsbdistcodename}-${openstack_version}" in $supported {

    if defined('$::http_proxy') and str2bool($::rfc1918_gateway) {
      $key_options = "http-proxy=${::http_proxy}"
    }
    else {
      $key_options = undef
    }

    apt::key { 'cloud-archive':
      id      => '391A9AA2147192839E9DB0315EDB1B62EC4926EA',
      server  => 'keyserver.ubuntu.com',
      options => $key_options,
      notify  => Exec['apt_update'],
    }

    apt::source { 'ubuntu-cloud-archive':
      location => $mirror_url,
      release  => "${::lsbdistcodename}-updates/${openstack_version}",
      repos    => 'main',
    }
  }
}
