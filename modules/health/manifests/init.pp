# Class: health
# ===========================
#
# Full description of class health here.
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
#    class { 'health':
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
# Copyright 2017 Your name here, unless otherwise noted.
#
class health {

    if $::os['family'] == 'windows'{
       $source_path='windows'
       $dest_path='c:/programdata/puppetlabs/facter/facts.d'
       file{"$dest_path":
          source  =>      "puppet:///modules/health/facts.d/${source_path}",
          purge   =>      true,
          force   =>      true,
          recurse =>      true
        }

    } else {
       $source_path='linux'
       $dest_path='/opt/puppetlabs/facter/facts.d'
       file{"$dest_path":
          mode    =>      '755',
          source  =>      "puppet:///modules/health/facts.d/${source_path}",
          purge   =>      true,
          force   =>      true,
          recurse =>      true
        }

       }

}
