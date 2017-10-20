# == Class: idcos::osinstall::dns
#
class idcos::osinstall::dns {
  # resources
  package { 'dnsmasq':
    ensure => installed,
  }

#这里还是有问题的，ini_setting
  ini_setting{
    default:
      ensure  => present,
      path    =>'/etc/dnsmasq.conf',
      notify  => Service['dnsmasq'];

    'address':
        setting =>'addess',
        value   =>'/osinstall/10.0.1.1';
    'address':
        setting =>'address',
        value   =>'/osinstall.idcos.net/10.0.1.1';
  }

  service { 'dnsmasq':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    # pattern => 'dnsmasq',
  }
}
