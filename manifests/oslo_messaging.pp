# Due to a bug in newer versions need to pin this in pike
# See https://bugs.launchpad.net/oslo.messaging/+bug/1800957
class openstack::oslo_messaging {

  $openstack_version = hiera('openstack_version')

  if $openstack_version == 'pike' {

    apt::pin { 'hold-oslo-messaging':
      packages => 'python-oslo.messaging',
      version  => '5.30.0-0ubuntu2~cloud0',
      priority => 1001,
    }
    apt::pin { 'hold-python-kombu':
      ensure   => 'absent',
      packages => 'python-kombu',
      version  => '3.0.33-1ubuntu2',
      priority => 1001,
    }
    apt::pin { 'hold-python-amqp':
      ensure   => 'absent',
      packages => 'python-amqp',
      version  => '1.4.9-1',
      priority => 1001,
    }
  }
}
