# == Class: idcos::osinstall::http
#
class idcos::osinstall::http {
  # resources
  package { 'nginx':
    ensure => installed,
  }



  service { 'nginx':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    # pattern => 'nginx',
  }
}
