# Installs the opentack ubuntu cloud archive
class openstack::repo::ubuntu(
  $mirror_url = 'http://mirrors.rc.nectar.org.au/ubuntu-cloud/ubuntu',
) {

  include nectar::repo::ubuntu

  $openstack_version = hiera('openstack_version')

  # Ubuntu uses the codename, not version for repos so convert
  case $openstack_version {
    '2023.1': { $openstack_version_real = 'antelope' }
    '2023.2': { $openstack_version_real = 'bobcat' }
    '2024.1': { $openstack_version_real = 'caracal' }
    default: { $openstack_version_real = $openstack_version }
  }

  $supported = ['bionic-rocky', 'bionic-stein', 'bionic-train', 'bionic-ussuri',
                'focal-victoria', 'focal-wallaby', 'focal-xena', 'focal-yoga',
                'jammy-zed', 'jammy-antelope', 'jammy-bobcat', 'jammy-caracal']

  $native_supported = ['bionic-queens', 'focal-ussuri', 'jammy-yoga']


  case "${facts['os']['distro']['codename']}-${openstack_version_real}" {

    *$supported: {

      apt::key { 'cloud-archive':
        id     => '391A9AA2147192839E9DB0315EDB1B62EC4926EA',
        server => 'keyserver.ubuntu.com',
        notify => Exec['apt_update'],
      }

      apt::source { 'ubuntu-cloud-archive':
        location => $mirror_url,
        release  => "${facts['os']['distro']['codename']}-updates/${openstack_version_real}",
        repos    => 'main',
      }
    }

    *$native_supported: {}

    default: {fail("${openstack_version_real} is not supported on ${facts['os']['distro']['codename']}")}
  }

  apt::source { "nectar-${openstack_version_real}":
    location => $nectar::repo::ubuntu::mirror_url,
    release  => "${facts['os']['distro']['codename']}-${openstack_version_real}",
    repos    => 'main',
    require  => Apt::Key['nectar'],
  }

  Apt::Source <| title == "nectar-${openstack_version_real}" |>
  -> Class['apt::update']
  -> Package <| tag == 'openstack' or tag == 'nectar' |>

}
