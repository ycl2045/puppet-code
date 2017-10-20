class nginx::service {
      service {'nginx':
                ensure => running,
                require => Package['nginx'],
      }
}
