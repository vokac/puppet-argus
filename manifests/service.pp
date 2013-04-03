class argus::service {
  service{'argus-pap':
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => [Class['argus::config'],Class['argus::install']]
  }
  service{'argus-pdp':
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => [Class['argus::config'],Class['argus::install']]
  }
  service{'argus-pepd':
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => [Class['argus::config'],Class['argus::install']]
  }
}
