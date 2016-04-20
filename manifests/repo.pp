class openstack::repo {

  $openstack_version = hiera('openstack_version')

  $supported_ubuntus = ['trusty', 'xenial']
  $supported_openstacks = ['juno', 'kilo', 'liberty']

  if $::lsbdistcodename in $supported_ubuntus {
    if $openstack_version in $supported_openstacks {

      if $::http_proxy and $::rfc1918_gateway == true {
        $key_options = "http-proxy=${::http_proxy}"
      }
      else {
        $key_options = false
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
        include_src => false,
      }
    }
  }
}
