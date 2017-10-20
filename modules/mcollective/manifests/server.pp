class mcollective::server($mqs) {
    tag 'mcollective_server'
	case $::os['family'] {
		/(RedHat|CentOS|AIX)/ :{
			$mcollective_dir = "/etc/puppetlabs/mcollective"
			$mcollective_lib = "/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/mcollective"

			file {'/opt/puppetlabs/puppet/bin/mcollectived':
                source  => 'puppet:///modules/mcollective/server/mcollectived',
                owner   =>      'root',
                group   =>      'root',
                mode    =>      '755',
            }
			file { "$mcollective_dir/facts.yaml":
				ensure	=>	file,
				mode	=>	'400',
				content	=>	template('mcollective/facts.yaml.erb'),
			}

			file {
				"$mcollective_dir/server_private.pem":
					owner   =>      'root',
                    group   =>      'root',
                    mode    =>      '600',
					source	=>	'puppet:///modules/mcollective/server/server_private.pem';
				"$mcollective_dir/server_public.pem":
					owner   =>      'root',
                    group   =>      'root',
                    mode    =>      '600',
					source	=>	'puppet:///modules/mcollective/server/server_public.pem';
				"$mcollective_dir/server.cfg":
					content	=>	template('mcollective/server-rabbitmq.cfg.erb');
				"$mcollective_dir/clients":
					mode	=>	'600',
					source	=>	'puppet:///modules/mcollective/server/clients',
					purge	=>	true,
					force	=>	true,
					recurse	=>	true;
				"$mcollective_lib":
					source	=>	'puppet:///modules/mcollective/plugins',
					recurse	=>	remote,
			} ~>
			service { 'mcollective':
				ensure	=>	running,
				enable	=>	true,
			}
		}
		/windows/ :{
			$mcollective_dir = "c:/programdata/puppetlabs/mcollective/etc"
			$mcollective_lib = "C:/puppetlabs/puppet/mcollective/lib/mcollective"
			file { "$mcollective_dir/facts.yaml":
				ensure	=>	file,
				mode	=>	'400',
				content	=>	template('mcollective/facts.yaml.erb'),
			}

			file {
				"$mcollective_dir/server_private.pem":
                   			 mode    =>      '600',
					source	=>	'puppet:///modules/mcollective/server/server_private.pem';
				"$mcollective_dir/server_public.pem":
                    			mode    =>      '600',
					source	=>	'puppet:///modules/mcollective/server/server_public.pem';
				"$mcollective_dir/server.cfg":
					content	=>	template('mcollective/server-rabbitmq.cfg.erb');
				"$mcollective_dir/clients":
					mode	=>	'600',
					source	=>	'puppet:///modules/mcollective/server/clients',
					purge	=>	true,
					force	=>	true,
					recurse	=>	true;
				"$mcollective_lib":
					source	=>	'puppet:///modules/mcollective/plugins',
					recurse	=>	remote,
			} ~>
			service { 'mcollective':
				ensure	=>	running,
				enable	=>	true,
			}
		}
		default :{
			fail("not support system")
		}
	}
}
