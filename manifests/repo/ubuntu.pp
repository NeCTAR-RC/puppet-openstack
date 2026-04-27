# Installs the opentack ubuntu cloud archive
class openstack::repo::ubuntu(
  String $mirror_url = 'http://mirrors.rc.nectar.org.au/ubuntu-cloud/ubuntu',
) {

  include nectar::repo::ubuntu

  package {'ubuntu-cloud-keyring':
    ensure => 'installed',
  }

  $openstack_version = lookup('openstack_version', Variant[String, Float])

  # Ubuntu uses the codename for cloud archive, not version for repos so convert
  case $openstack_version {
    '2023.1': { $openstack_codename = 'antelope' }
    '2023.2': { $openstack_codename = 'bobcat' }
    '2024.1': { $openstack_codename = 'caracal' }
    2023.1: { $openstack_codename = 'antelope' }
    2023.2: { $openstack_codename = 'bobcat' }
    2024.1: { $openstack_codename = 'caracal' }
    2024.2: { $openstack_codename = 'dalmation' }
    2025.1: { $openstack_codename = 'epoxy' }
    2025.2: { $openstack_codename = 'flamingo' }
    2026.1: { $openstack_codename = 'gazpacho' }
    2026.2: { $openstack_codename = 'hibuscus' }
    default: { $openstack_codename = $openstack_version }
  }

  if $openstack_version !~ String {
    notify{'openstack::repo::ubuntu::openstack_version':
      message => 'openstack_version should be type String, not type Float, this will break in future release',
    }
    warning('openstack_version is type Float, should be type String')
  }

  $supported = ['focal-victoria', 'focal-wallaby', 'focal-xena', 'focal-yoga',
                'jammy-zed', 'jammy-2023.1', 'jammy-2023.2', 'jammy-2024.1',
                'noble-2024.2', 'noble-2025.1', 'noble-2025.2', 'noble-2026.1']

  $native_supported = ['focal-ussuri', 'jammy-yoga']


  case "${facts['os']['distro']['codename']}-${openstack_version}" {

    *$supported: {

      apt::source { 'ubuntu-cloud-archive':
        location => $mirror_url,
        release  => "${facts['os']['distro']['codename']}-updates/${openstack_codename}",
        repos    => 'main',
      }
    }

    *$native_supported: {}

    default: {
      warning("${openstack_version} is not supported on ${facts['os']['distro']['codename']}")
    }
  }

  apt::source { "nectar-${openstack_version}":
    location => $nectar::repo::ubuntu::mirror_url,
    release  => "${facts['os']['distro']['codename']}-${openstack_version}",
    repos    => 'main',
    keyring  => '/etc/apt/keyrings/nectar.gpg',
  }

  Apt::Source <| title == "nectar-${openstack_version}" |>
  -> Class['apt::update']
  -> Package <| tag == 'openstack' or tag == 'nectar' |>

}
