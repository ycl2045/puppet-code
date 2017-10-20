# Class: java
# ===========================
#
# Full description of class java here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'java':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class jdk(
	$version	= '6',	
	$jdk_repository	=	undef,
) 
    inherits jdk::params
{
	$jdk_install_file = $version ? {
		'6'	=>	"jdk-6u101-windows-x64.exe",
	}
	
    Exec{
		provider => $provider,
		path	=>	"$::path;c:/puppetlabs/bin",
	}

	exec{"mk $media_dir":
		command    =>    "$mkdir $media_dir",
		unless	=>	"cmd.exe /c dir $media_dir",
	}

    file { "${media_dir}/${jdk_install_file}":
        ensure => file,
        #source  =>  "puppet:///modules/jdk/${jdk_install_file}",
        source  =>  "http://${jdk_repository}/middleware/${jdk_install_file}",
	mode	=>	'755',
	notify	=>	Exec["$jdk_install_file"],
    }

    exec{"mk $java_home":
		command    =>    "$mkdir $java_home",
		unless	=>	"cmd.exe /c dir ${java_home}",
	}


   exec{"$jdk_install_file":
   	command =>  $jdk_install_command,
	unless	=>	"cmd.exe /c dir d:\\data\\middleware\\java\\jdk1.6.0_101\\bin\\java.exe",
       	cwd =>  $java_home,
	refreshonly	=>	true,
   }
}
