# Installs the opentack ubuntu cloud archive
class openstack::repo::redhat {

  $openstack_version = hiera('openstack_version')

  # installs RDO train for RHEL8
  case $facts['os']['release']['major'] {
    '8': {
#      package { 'rdo-release':
#        source => 'https://www.rdoproject.org/repos/rdo-release.el8.rpm',
#      }
      yumrepo { "openstack-$openstack_version":
        name => 'rdo-release-train',
        descr => 'OpenStack Train Repository',
        baseurl => 'http://mirror.centos.org/centos/$releasever/cloud/$basearch/openstack-train/',
        gpgcheck => 1,
        enabled => 1,
        gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud'
      }
    }
  }
}
