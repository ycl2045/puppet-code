# == Class: idcos::dcosexec
#
class idcos::dcosexec(
  $db_source='dcosdb.qdn.hfdev',
  $db_name='puppet-test',
  $db_port='3306',
  $puppetdburl='http://55.3.15.148:8080',
  ) {
  # resources
  augeas { 'metadata_expire':
    context  => '/files/etc/yum.conf',
    changes =>  'set main/metadata_expire 1m',
  }
  package { 'puppet-config':
    ensure =>  installed,
  }

  ini_setting {
    default:
    ensure  =>  present,
    path  => '/usr/yunji/puppet-config/conf/puppet-config.ini',
    notify  =>  Service['puppet-conf'];
    'repo':
    section =>  'Repo',
    setting =>  'connection',
    value =>  "root:P@ssw0rd@tcp(${db_source}:${db_port})/${db_name}?charset=utf8&parseTime=True&loc=Local";
    'puppetdb':
    section =>  'Puppet',
    setting =>  'puppetDBURL',
    value =>  $puppetdburl;
  }
  service {'puppet-conf':
    ensure => running,
    start =>'nohup /usr/local/bin/api-server run >/tmp/nohup.log 2>&1 &',
  }
}
