class puppet::pgsql($pg_puppetdb_passwd) {
	package { 'postgresql94-server':
		ensure	=>	installed,
		notify	=>	[Exec['pg_initdb'],Exec['pg_create_puppet_user'],Exec['pg_create_puppet_db'],Exec['pg_puppetdb_extension']],
	}
	package { 'postgresql94-contrib':
		ensure	=>	installed,
	}
	exec { 'pg_initdb':
		command		=>	'/usr/pgsql-9.4/bin/postgresql94-setup initdb',
		refreshonly	=>	true,
	}
	exec { 'pg_create_puppet_user':
		command		=>	'psql -c "create user puppetdb with password \'${pg_puppetdb_passwd}\'"',
		user		=>	'postgres',
		refreshonly	=>	true,
		require		=>	Service['postgresql-9.4'],
	}
	exec { 'pg_create_puppet_db':
		command		=>	'createdb -E UTF8 -O puppetdb puppetdb',
		user		=>	'postgres',
		refreshonly	=>	true,
		require		=>	Service['postgresql-9.4'],
	}
	exec { 'pg_puppetdb_extension':
		command		=>	"psql puppetdb -c 'create extension pg_trgm'",
		user		=>	'postgres',
		refreshonly	=>	true,
		require		=>	[Service['postgresql-9.4'],Package['postgresql94-contrib']],
	}

	file { '/var/lib/pgsql/9.4/pg_hba.conf':
		content	=>	template('puppet/pgsql/pg_hba.conf.erb'),
		owner	=>	'root',
		group	=>	'root',
		mode	=>	'600',
		notify	=>	Service['postgresql-9.4'],
	}

	file { '/var/lib/pgsql/9.4/postgresql.conf':
		source	=>	'puppet:///modules/puppet/pgsql/postgresql.conf',
		owner	=>	'root',
		group	=>	'root',
		mode	=>	'600',
		notify	=>	Service['postgresql-9.4'],
	}
	
	service { 'postgresql-9.4':
		ensure	=>	running,
		enable	=>	true,
		require	=>	Exec['pg_initdb'],
	}
	
	Exec {
		path	=>	'/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/root/bin:/usr/pgsql-9.4/bin/',
	}
}
