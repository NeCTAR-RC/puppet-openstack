# Installs the opentack ubuntu cloud archive
class openstack::repo::redhat {

  $openstack_version = hiera('openstack_version')

  # installs RDO train for RHEL8
  case $::facts['os']['release']['major'] {
    '8': {
      case $openstack_version {
        'train': {
          package { 'rdo-release':
            source => 'https://repos.fedorapeople.org/repos/openstack/openstack-train/rdo-release-train-4.el8.noarch.rpm',
          }
        }
        'ussuri': {
          package { 'rdo-release':
            source => 'https://repos.fedorapeople.org/repos/openstack/openstack-ussuri/rdo-release-ussuri-3.el8.noarch.rpm',
          }
        }
        default: {
          # the default rdo-release package for RHEL8 installs the victoria repo
          package { 'rdo-release':
            source => 'https://www.rdoproject.org/repos/rdo-release.el8.rpm',
          }
        }
      }
    }
    default: {
      fail("RedHat/CentOS version ${::facts['os']['release']['major']} is not supported")
    }
  }
}
