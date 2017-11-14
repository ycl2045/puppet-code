Exec {
    path    =>    '/bin:/usr/bin:/sbin:/usr/sbin:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/usr/local/bin',
}

case $::os['family'] {
	/(RedHat|CentOS|AIX)/ :{
		class {"mcollective::server": mqs => [{"passwd" => "yunjikeji","host" => "puppet"}], tag => ['mcollective_server']}
        class {"puppet::agent": tag=> ['puppetagent']}
        include health
	    augeas { 'yum_metadata_expire':
		    context	=>	'/files/etc/yum.conf',
		    changes	=>	"set main/metadata_expire 1m",
	    }
	}
	/windows/ :{
		class {"mcollective::server": mqs => [{"passwd" => "yunjikeji","host" => "puppet"}], tag => ['mcollective_server']}
    	class {"puppet::agent": tag=> ['puppetagent']}
        include health
	}
	default :{
			fail("not support system")
		}
}

Yumrepo <| |> -> Package <| |> -> Ini_setting <| |>


if $resources {
    $resources.each |$res_type, $res_value| {
        create_resources($res_type, $res_value)
    }
}
