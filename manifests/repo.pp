# Installs the openstack repo for the respective distros
class openstack::repo {
  case $facts['os']['name'] {
    'Ubuntu': {
      include openstack::repo::ubuntu
    }
    'RedHat': {
      include openstack::repo::redhat
    }
  }
}
