#These are needed almost everywhere
class openstack::package {
  ensure_packages(['python-keystone','python-memcache'])
}
