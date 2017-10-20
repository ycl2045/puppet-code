class puppet::nginx($port = '8140',$servers) {
	package { 'nginx':
		ensure	=>	installed,
	}

	File{
		owner => 'root',
		group => 'root',
		mode => '644',
	}
	
	#file{'/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem':
	#	source => 'puppet:///modules/puppet/nginx/ca/ca_crl.pem';
	#	'/etc/puppetlabs/puppet/ssl/certs/puppet.pem':
	#	source => 'puppet:///modules/puppet/nginx/certs/puppet.pem';
	#	'/etc/puppetlabs/puppet/ssl/private_keys/puppet.pem':
	#	source => 'puppet:///modules/puppet/nginx/private_keys/puppet.pem';
	#	}

	file { '/etc/nginx/conf.d/puppet.conf':
		content	=>	template('puppet/nginx/puppet.conf.erb'),
	} ~>
	service { 'nginx':
		ensure	=>	running,
		enable	=>	true,
	}
}
