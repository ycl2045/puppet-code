# == Class: puppet::agent
#
class puppet::agent (
   # resources
   $env  =  'production',
   ){
    tag 'puppetagent'
    $min = fqdn_rand(1200) + 1800
    case $::os['family'] {
     /(RedHat|CentOs)/:{
        $puppet_conf_dir='/etc/puppetlabs/puppet'
        file {'/usr/bin/puppet':
            ensure  =>  link,
            target  =>  '/opt/puppetlabs/bin/puppet'
        }
        ini_setting {
        default:
            ensure  =>  present,
            path  =>  "${puppet_conf_dir}/puppet.conf";
            'environment':
                section =>  'main',
                setting =>  'environment',
                value =>  $env;
            'certificate_revocation':
                section =>  'agent',
                setting =>  'certificate_revocation',
                value =>  false;
            'report':
                section =>  'agent',
                setting =>  'report',
                value =>  'true';
            'runinterval':
                section =>  'agent',
                setting =>  'runinterval',
                value   =>  "${min}";
            'http_read_timeout':
                section =>  'agent',
                setting =>  'http_read_timeout',
                value   =>  "360";

        }
        augeas { 'certname':
                context =>  '/files/etc/puppetlabs/puppet/puppet.conf',
                changes =>  "set agent/certname ${ipaddress}",
                onlyif =>  'get agent/certname == ""',
                notify  => Service['puppet'],
        }

        service { 'puppet':
                ensure  =>      running,
                enable  =>      true,
        }

       }
     /windows/ :{
        $puppet_conf_dir='C:/ProgramData/PuppetLabs/puppet/etc'
        ini_setting {
        default:
            ensure  =>  present,
            path  =>  "${puppet_conf_dir}/puppet.conf";
            'environment':
                section =>  'main',
                setting =>  'environment',
                value =>  $env;
            'certificate_revocation':
                section =>  'agent',
                setting =>  'certificate_revocation',
                value =>  false;
            'report':
                section =>  'agent',
                setting =>  'report',
                value =>  'true';
             'noop':
                section =>      'agent',
                setting =>      'noop',
                value   =>      'false';
            'runinterval':
                section =>  'agent',
                setting =>  'runinterval',
                value   =>  "${min}";
            'http_read_timeout':
                section =>  'agent',
                setting =>  'http_read_timeout',
                value   =>  "360";

    }
        service { 'puppet':
                ensure  =>      running,
                enable  =>      true,
        }
       }
   default :{

       fail("This system not support !!")
     }
    }
}
