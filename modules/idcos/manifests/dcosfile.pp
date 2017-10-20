# == Class: idcos::dcosfile
#
class idcos::dcosfile {
  # resources

  package { [
    'nginx',
    'rpm-build',
    'createrepo',
  ]:
    ensure => installed,
  }

  # nginx conf file

  file { '/etc/nginx/conf.d/default.conf':
    content =>  template('idcos/dcosfile/default.conf.erb'),
    ensure => file,
    mode => '0644',
    notify => Service['nginx'],
  }

  service { 'nginx':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    # pattern => 'nginx',
  }


  # nexus for marven repository
  # require puppet version >4.4
  # 一些非标准的[不是rpm包]的软件包，都放到介质库的idcos目录[/home/www/idcos]
  file { '/var/idcos/nexus-2.12.0-01-bundle.tar.gz':
    source  =>  'http://dcosfile.qdn.hfdev:/idcos/nexus-2.12.0-01-bundle.tar.gz',
    mode => '0644',
  }

  exec { 'tar -xzf nexus-2.12.0-01-bundle.tar.gz':
    cwd     =>  '/var/idcos',
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    require =>  File['/var/idcos/nexus-2.12.0-01-bundle.tar.gz'],
    # refreshonly => true,
  }

  host { 'nexus':
    ensure => 'present',
    name => 'nexus',
    ip => '127.0.0.1',
  }

  service { 'nexus start':
    ensure => running,
    start     =>  'export RUN_AS_USER=root && /var/idcos/nexus-2.12.0-01/bin/nexus start',
    # pattern => 'nexus start',
  }

}
