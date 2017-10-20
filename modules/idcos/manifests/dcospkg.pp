# == Class: idcos::dcospkg
#
class idcos::dcospkg{
  $enterprise_nui_url = "http://55.3.15.142:8080",
  $user='root',
  $user_password='hengfeng',
  $db_ip='dcosdb.qdn.hfdev',
  $db_uer='root',
  $db_password='P@ssw0rd',
  $tarurl='http://locahost:8081',
  $rpmurl='http://localhost:8081',
  $shellurl='http://localhost:8081'
  } {
  # resources
  enterprise_nui
  package { ['idcos-cloud-manager',
    'idcos-enterprise-nui',
    'idcos-shell-service',
    'rpm-build',
    'nginx',
    'tomcat']:
    ensure => installed,
  }

  file { '/usr/local/bin/rpmbuild.sh':
    source  => 'puppet:///modules/idcos/dcospkg/rpmbuild.sh',
    owner   =>  'root',
    group   =>  'root',
    mode => '0755',
  }

  file { '/etc/nginx/conf.d/default.conf':
    content =>  template('idcos/dcospkg/default.conf.erb'),
    mode => '0644',
    notify  =>  Service['nginx'],
  }

  file { '/etc/shell_service.ini':
    content=>template('idcos/dcospkg/shell_service.ini.erb'),
    mode => '0644',
    notify=>Service['idcos-shell-service'],
  }

  file { 'name':
    path=>'/usr/yunji/idcos-cloud-manager/bin/ROOT/WEB-INF/classes/app.properties',
    content=>template('idcos/dcospkg/app.properties.erb'),
    mode => '0644',
    notify=>Service['tomcat'],
  }
  service { 'nginx':
    ensure => running,
    # pattern => 'nginx',
  }

  service { 'idcos-shell-service':
    ensure => running,
    # pattern => 'idcos-shell-service',
  }

  service { 'tomcat':
    ensure => running,
    # pattern => 'tomcat',
  }

}
