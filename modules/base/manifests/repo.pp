class base::repo(
  $repurl  = "55.3.15.145", 
  $metadata_expire = "1m",
  ) {
  # resources

  augeas { 'yum_metadata_expire':
    context	=>	'/files/etc/yum.conf',
    changes	=>	"set main/metadata_expire ${metadata_expire}",
  }
  $family = inline_template('<%= @os["name"].downcase %>')
	if $os['family'] == 'RedHat' {
  		yumrepo { 'idcos':
		ensure	=> present,
    	baseurl	=>	"http://${repurl}/$family/${os['release']['major']}/os/${os['hardware']}",
    	descr => 'The idcos repository',
    	enabled => '1',
    	gpgcheck => '0',
    	gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-idcos',
  	}
	}
}
