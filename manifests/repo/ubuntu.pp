# Installs the opentack ubuntu cloud archive
class openstack::repo::ubuntu(
  $mirror_url = 'http://mirrors.rc.nectar.org.au/ubuntu-cloud/ubuntu',
) {

  include nectar::repo::ubuntu

  $openstack_version = hiera('openstack_version')

  $supported = ['trusty-juno', 'trusty-kilo', 'trusty-liberty', 'trusty-mitaka',
                'xenial-newton', 'xenial-ocata', 'xenial-pike', 'xenial-queens',
                'bionic-rocky', 'bionic-stein', 'bionic-train', 'bionic-ussuri',
                'focal-victoria', 'focal-wallaby', 'focal-xena', 'focal-yoga',
                'jammy-zed',]

  $native_supported = ['bionic-queens', 'focal-ussuri', 'jammy-yoga']


  case "${::lsbdistcodename}-${openstack_version}" {

    *$supported: {
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

    *$native_supported: {}

    default: {fail("${openstack_version} is not supported on ${::lsbdistcodename}")}
  }

  apt::source { "nectar-${openstack_version}":
    location => $mirror_url,
    release  => "${::lsbdistcodename}-${openstack_version}",
    repos    => 'main',
    require  => Apt::Key['nectar'],
  }

  Apt::Source <| title == "nectar-${openstack_version}" |>
  -> Class['apt::update']
  -> Package <| tag == 'openstack' or tag == 'nectar' |>

}
