# == Class: idcos::osinstall::serverapi
#
class idcos::osinstall::serverapi {
  # resources
  package { 'osinstall-server':
    ensure => installed,
  }

  file { '/etc/osinstall-server/osinstall-server.conf':
    content  => template('idcos/osinstall/serverapi/osinstall-server.conf.erb'),
    owner   =>  'root',
    group   =>  'root',
    mode => '0644',
  }

  service { 'osinstall-server':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    # pattern => 'osinstall-server',
  }
}
