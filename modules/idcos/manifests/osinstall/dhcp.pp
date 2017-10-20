# == Class: idcos::osinstall::dhcp
#
class idcos::osinstall::dhcp {
  # resources

  #next-server 指向tftp服务器，默认是本机ip
  #domain-name-servers 指向dns服务器，默认是本机ip
  #domain-search dns搜索域，请根据实际情况修改
  #root-path 指向客户端的根路径，默认是本机ip
  #subnet 分配的dhcp网段，请根据实际情况修改

    package { 'dhcp':
      ensure => installed,
    }

    file { '/etc/dhcp/dhcp.conf':
      content => template('idcos/dhcp/dhcp.conf.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644',
      notify  => Service['dhcp'],
    }

    service { 'dhcp':
      ensure => running,
      enable => true,
      hasrestart => true,
      hasstatus  => true,
      require   => Package['dhcp'],
      # pattern => 'dhcp',
    }
}
