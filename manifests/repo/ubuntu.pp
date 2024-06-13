# Installs the opentack ubuntu cloud archive
class openstack::repo::ubuntu(
  String $mirror_url = 'http://mirrors.rc.nectar.org.au/ubuntu-cloud/ubuntu',
) {

  include nectar::repo::ubuntu

  $openstack_version = lookup('openstack_version', Variant[String, Float])

  # Ubuntu uses the codename, not version for repos so convert
  case $openstack_version {
    '2023.1': { $openstack_version_real = 'antelope' }
    '2023.2': { $openstack_version_real = 'bobcat' }
    '2024.1': { $openstack_version_real = 'caracal' }
    2023.1: { $openstack_version_real = 'antelope' }
    2023.2: { $openstack_version_real = 'bobcat' }
    2024.1: { $openstack_version_real = 'caracal' }
    default: { $openstack_version_real = $openstack_version }
  }

  if type($openstack_version) != Type[String] {
    notify{'openstack::repo::ubuntu::openstack_version':
      message => 'openstack_version should be type String, not type Float, this will break in future release',
    }
    warning('openstack_version is type Float, should be type String')
  }

  $supported = ['focal-victoria', 'focal-wallaby', 'focal-xena', 'focal-yoga',
                'jammy-zed', 'jammy-antelope', 'jammy-bobcat', 'jammy-caracal']

  $native_supported = ['focal-ussuri', 'jammy-yoga']


  case "${facts['os']['distro']['codename']}-${openstack_version_real}" {

    *$supported: {

      apt::key { 'cloud-archive':
        id     => '391A9AA2147192839E9DB0315EDB1B62EC4926EA',
        source => 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x391a9aa2147192839e9db0315edb1b62ec4926ea',
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
