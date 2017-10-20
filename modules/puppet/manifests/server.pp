class puppet::server($puppetdb = false, $db_server_urls='') {
	package { 'puppetserver':
		ensure	=>	installed,
	}

	ini_setting {
	default:
		ensure  =>  present,
		path  =>  "/etc/puppetlabs/puppet/puppet.conf",
		section	=>	'main';
	'vardir':
		setting =>  'vardir',
		value =>  '/opt/puppetlabs/server/data/puppetserver';
	'logdir':
		setting	=>	'logdir',
		value	=>	'/var/log/puppetlabs/puppetserver';
	'rundir':
		setting	=>	'rundir',
		value	=>	'/var/run/puppetlabs/puppetserver';
	'pidfile':
		setting=>'pidfile',
		value	=>'/var/run/puppetlabs/puppetserver/puppetserver.pid';
	'codedir':
		setting	=>'codedir',
		value	=>'/etc/puppetlabs/code';
	'autosign':
		setting	=>'autosign',
		value	=>'true';
	'node_terminus':
		setting	=>'node_terminus',
		value	=>'exec';
	'external_nodes':
		setting=>'external_nodes',
		value	=>'/etc/puppetlabs/enc.rb';
	}	



	service { 'puppetserver':
		ensure	=>	running,
		enable	=>	true,
	}

	if $puppetdb == 'true' {
		package { 'puppetdb-termini':
			ensure	=>	installed,
		}
	ini_setting{
	default:
		ensure  =>  present,
		path  =>  "/etc/puppetlabs/puppet/puppet.conf",
		section	=>	'master';
	'storeconfigs':
		setting	=>'storeconfigs',
		value	=>'true';
	'storeconfigs_backend':
		setting	=>'storeconfigs_backend',
		value	=>'puppetdb';
	'reports':
		setting=>'reports',
		value	=>'store,puppetdb';
	}	

	file { '/etc/puppetlabs/puppet/puppetdb.conf':
			content	=>	template('puppet/server/puppetdb.conf.erb'),
			owner	=>	'root',
			group	=>	'root',
			mode	=>	'644',
			notify	=>	Service['puppetserver'],
	}
	file { '/etc/puppetlabs/puppet/routes.yaml':
			source	=>	'puppet:///modules/puppet/server/routes.yaml',
		}
	}
}

