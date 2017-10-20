# == Class: idcos::osinstall::tftp
#
class idcos::osinstall::tftp {
  # resources
  package { ['tftp-server,syslinux-tftpboot']:
    ensure => installed,
  }

  # 配置 tftp 配置文件

  file { '/var/lib/tftpboot/pxelinux.cfg/default':
    content   =>  template('idcos/osinstall/bootos/default.erb'),
    owner     =>  'root',
    group     =>  'group',
    mode => '0644',
  }

  ini_setting{
    default:
        ensure  => present,
        path    => '/etc/xinetd.d/tftp',
        notify  =>  Service['tftp'];
    'disable':
        setting =>'disable',
        value   =>'no';
      'server_args':
        setting =>'server_args',
        value   =>'-s /var/lib/tftpboot';
  }

  service { 'tftp':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    # pattern => 'tftp',
  }

}
