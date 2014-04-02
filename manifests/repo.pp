class openstack::repo {

  $openstack_version = hiera('openstack_version')

  if $lsbdistcodename == 'precise' {

    apt::key { 'cloud-archive':
      key         => 'EC4926EA',
      key_server => 'pgp.mit.edu',
    }

    apt::source { 'ubuntu-cloud-archive':
      location          => 'http://mirrors.melbourne.nectar.org.au/ubuntu-cloud/ubuntu',
      release           => "${lsbdistcodename}-updates/${openstack_version}",
      repos             => 'main',
      include_src       => false,
    }
  }
}
