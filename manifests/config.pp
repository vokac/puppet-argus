class argus::config inherits params {
  
  # create gridmapfile and groupmapfiles
  class {'hostcertificate::gridcertificate':}

  # voms crap
  include voms::atlas
  include voms::cms
  include voms::lhcb
  include voms::alice
  include voms::dteam
  include voms::ops
  include voms::aleph 
  include voms::delphi
  include voms::ilc
  include voms::envirogrids
  include voms::geant4
  include voms::na48
  include voms::unosat
  include voms::gear
  include voms::sixt
  
  file {"/etc/grid-security/gridmapdir":
    ensure => directory,
    owner => "root",
    group => "root",
    mode => 0700,
  }  

  #
  # configuration files: fixme: some parameters ares still hard coded
  #
  file {"/usr/share/argus/pap/conf/pap_configuration.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0640,
    content => template("argus/pap_configuration.ini.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pap'],
  }
  file {"/usr/share/argus/pap/conf/pap_authorization.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0640,
    content => template("argus/pap_authorization.ini.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pap'],
  }
  file {"/usr/share/argus/pap/conf/pap-admin.properties":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("argus/pap-admin.properties.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pap'],
  }
  file {"/etc/argus/pdp/pdp.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0640,
    content => template("argus/pdp.ini.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pdp'],
  }
  file {"/usr/share/argus/pepd/conf/pepd.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0640,
    content => template("argus/pepd.ini.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pepd'],
  }
  
  class {'vosupport':
    supported_vos => [atlas, cms, lhcb, alice, dteam, ops, 'vo.aleph.cern.ch', 'vo.delphi.cern.ch', 'vo.l3.cern.ch', 
                      'vo.opal.cern.ch', ilc, 'envirogrids.vo.eu-egee.org', geant4, na48, unosat, 'vo.gear.cern.ch',
                      'vo.sixt.cern.ch'], #prod.vo.eu-eela.eu: missing voms
    enable_mappings_for_service => 'ARGUS',
    enable_poolaccounts => false,
    enable_environment => false,
    enable_voms => true,
  }
  
  File['/usr/share/argus/pap/conf/pap_configuration.ini','/etc/grid-security/gridmapdir','/usr/share/argus/pap/conf/pap_authorization.ini','/usr/share/argus/pap/conf/pap-admin.properties','/etc/argus/pdp/pdp.ini','/usr/share/argus/pepd/conf/pepd.ini'] -> Class['vosupport','hostcertificate::gridcertificate'] 
  
}
