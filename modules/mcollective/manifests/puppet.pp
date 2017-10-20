class mcollective::puppet ($puppetserver) {
	# generate server key
	exec { 'generate_server_key':
		command => "/opt/puppetlabs/puppet/bin/puppet cert generate mcollective-server",
		logoutput	=>	on_failure,
		creates	=>	"/etc/puppetlabs/puppet/ssl/certs/mcollective-server.pem",
	}

	file { 
		'/etc/puppetlabs/code/modules/mcollective/files/server/server_public.pem':
			source	=>	'/etc/puppetlabs/puppet/ssl/certs/mcollective-server.pem';
		'/etc/puppetlabs/code/modules/mcollective/files/server/server_private.pem':
			source	=>	'/etc/puppetlabs/puppet/ssl/private_keys/mcollective-server.pem';
		'/etc/puppetlabs/code/modules/mcollective/files/server/clients':
			ensure	=>	directory;
		"/etc/puppetlabs/code/modules/mcollective/files/server/clients/$puppetserver.pem":
			ensure	=>	directory,
			source	=>	"/etc/puppetlabs/puppet/ssl/certs/$puppetserver.pem";
	}
}
