# == Class: idcos::osinstall::webserver
#
class idcos::osinstall::webserver {
  # resources
  file { '/home/www':
    ensure => directory,
    mode => '0644',
  }

  archive{'web-server':
    ensure  =>  present,
    url =>"$yum_url/idcos-osinstall-ui.tar.gz",
    target  =>'/home/www/',
  }

  file { '/etc/nginx/conf.d/default.conf':
    source  => 'puppet:///modules/idcos/osinstall/nginx/default.conf.erb',
    owner   =>'root',
    group   =>'root',
    mode => '0644',
    notify  => Service['nginx'],
  }

  service { 'nginx':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    # pattern => 'nginx',
  }
}
