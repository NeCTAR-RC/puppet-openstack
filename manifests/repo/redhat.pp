# Installs the opentack ubuntu cloud archive
class openstack::repo::redhat {

  $openstack_version = hiera('openstack_version')

  # installs RDO train for RHEL8
  case $::facts['os']['release']['major'] {
    '8': {
      case $openstack_version {
        'train': {
          # rdo-release for RHEL8 installs the ussuri repo, we need train repo
          # for neutron-linuxbridge-agent.
          yumrepo { 'openstack-train':
            name     => 'rdo-release-train',
            descr    => 'OpenStack Train Repository',
            baseurl  => 'http://mirror.centos.org/centos/$releasever/cloud/$basearch/openstack-train/',
            gpgcheck => 1,
            enabled  => 1,
            gpgkey   => 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud',
          }
        }
        default: {
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
