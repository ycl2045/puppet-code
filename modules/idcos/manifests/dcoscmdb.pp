# == Class: idcos::dcoscmdb
#
class idcos::dcoscmdb(
    $activemq = 'dcosdb.qdn.hfdev',
    $activemq_port = '61616',
    $mongodb  =   'dcosdb.qdn.hfdev',
  ) {
  # resources
augeas { 'metadata_expire':
    context =>  '/files/etc/yum.conf',
    changes =>  'set main/metadata_expire 1m',
}
package { ['hf-cmdbs','tomcat']:
  ensure => installed,
}
exec { 'unzip ROOT.war -d ROOT':
  cwd =>  '/usr/yunji/hf-cmdbs/bin/',
  onlyif  =>  'test -f /usr/yunji/hf-cmdbs/bin/ROOT.war',
  creates =>  '/usr/yunji/hf-cmdbs/bin/ROOT',
  path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  # refreshonly => true,
}
ini_setting {
  default:
    ensure  =>  present,
    path  =>  '/usr/yunji/hf-cmdbs/bin/ROOT/WEB-INF/classes/application-default.properties',
    notify  =>  Service['tomcat'];
    'db.path':
    setting =>  'db.path',
    value =>  '/var/lib/neo4j-data/hf-cmdbs';
    'jms.url':
    setting =>  'jms.url',
    value =>  "failover://(tcp://${activemq}:${activemq_port})?randomize=false&timeout=5000&maxReconnectAttempts=-1";
    'mongo.host':
    setting =>  'mongo.host',
    value =>  $mongodb;
}
service { 'tomcat':
  ensure  =>  running,
}

}
