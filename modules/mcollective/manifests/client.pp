class mcollective::client($mqs) {
	# client config file
	file { "/etc/puppetlabs/mcollective/client.cfg":
		content	=>	template('mcollective/client-rabbitmq.cfg.erb'),
		notify	=>	Service['mcollective'],
	}

	# client for shell plugin
	file { "/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/mcollective/application":
		source	=>	'puppet:///modules/mcollective/plugins/application',
		recurse	=>	remote,
	}
}
