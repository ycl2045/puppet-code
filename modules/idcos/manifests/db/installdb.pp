# == Define: idcos::db::installdb
#
define idcos::db::installdb (
  $sql_file='',

  ) {
  # resources

  # install mysql

  file { '/tmp/idcos-osinstall-initial.sql':
    source  => 'puppet:///modules/idcos/db/idcos-osinstall-initial.sql',
    mode => '0644',
  }

  class {'mysql::server':
  root_password           => 'P@ssw0rd',
  }

  mysql::db { 'idcos-osinstall':
    user     => 'idcos',
    password => 'idcos',
    host     => '%',
    grant    => ['SELECT', 'UPDATE'],
    sql      => '/tmp/idcos-osinstall-initial.sql',
    import_timeout => 900,
  }


  # install mongodb
  class { '::mongodb::globals': manage_package_repo => true }->
  class {'mongodb::server':
    port    => 27017,
    bind_ip => '0.0.0.0',
    verbose => true,
    }

    #class {'::mongodb::client':}

}
