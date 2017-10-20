class mcollective::activemq(
	$ks_passwd,
	$mc_passwd,
        $puppetserver
	){
	
	package { 'activemq':
		ensure	=>	installed,
	}
	
	# create truststore and keystore
	java_ks { 'activemq_ca:truststore':
		ensure			=>	latest,
		certificate		=>	'/etc/puppetlabs/puppet/ssl/certs/ca.pem',
		target			=>	'/etc/activemq/truststore.jks',
		password		=>	$ks_passwd,
		trustcacerts	=>	true,
	}
	java_ks { 'activemq_cert:keystore':
		ensure		=>	latest,
		certificate	=>	"/etc/puppetlabs/puppet/ssl/certs/$puppetserver.pem",
		private_key	=>	"/etc/puppetlabs/puppet/ssl/private_keys/$puppetserver.pem",
		target		=>	'/etc/activemq/keystore.jks',
		password	=>	$ks_passwd,
	}

	file { '/etc/activemq/activemq.xml':
		content		=>	template('mcollective/activemq.xml.erb'),
		owner		=>	'activemq',
		group		=>	'activemq',
		mode		=>	'400',
	} ~>
	service { 'activemq':
		ensure	=>	running,
		enable	=>	true,
	}
}
