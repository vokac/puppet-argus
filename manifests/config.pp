class argus::config (
  $bdii                 = argus::params::bdii,
  $use_vofiles          = argus::params::use_vofiles,
) inherits argus::params {

  #
  # configuration files
  #

  concat{"/usr/share/argus/pap/conf/pap_configuration.ini":
    owner =>  'root',
    group =>  'root',
    mode  =>  '0640',
    require => Package['argus-pap'],
    notify  => Service['argus-pap'],
  }


  concat::fragment{"pap_configuration.ini": 
    target  => "/usr/share/argus/pap/conf/pap_configuration.ini",
    order   => "9",
    content => template("argus/pap_configuration.ini.erb"),
  }



  file {"/usr/share/argus/pap/conf/pap_authorization.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => '0640',
    content => template("argus/pap_authorization.ini.erb"),
    require => Package['argus-pap'],
    notify  => Service['argus-pap'],
  }

  file {"/usr/share/argus/pap/conf/pap-admin.properties":
    ensure => present,
    owner => "root",
    group => "root",
    mode => '0644',
    content => template("argus/pap-admin.properties.erb"),
    require => Package['argus-pap'],
    notify  => Service['argus-pap'],
  }

  file {"/etc/argus/pdp/pdp.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => '0640',
    content => template("argus/pdp.ini.erb"),
    require => Package['argus-pdp'],
    notify  => Service['argus-pdp'],
  }

  file {"/etc/argus/pdp/logging.xml":
    ensure => present,
    owner => "root",
    group => "root",
    mode => '0644',
    content => template("argus/pdp/logging.xml.erb"),
    require => Package['argus-pdp'],
    notify  => Service['argus-pdp'],
  }

  file {"/usr/share/argus/pepd/conf/pepd.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => '0640',
    content => template("argus/pepd.ini.erb"),
    require => Package['argus-pep-server'],
    notify  => Service['argus-pepd'],
  }

  include 'argus::centralbanning'

  if $use_vofiles {

    file {"/etc/grid-security/gridmapdir":
      ensure => directory,
      owner => "root",
      group => "root",
      mode => '0755',
      recurse => true,
      require => Package['argus-pep-server'],
      notify  => Service['argus-pepd'],
    }

    file {"/etc/grid-security/grid-mapfile":
      ensure => present,
      owner => "root",
      group => "root",
      mode => '0644',
      content => $grid_mapfile,
      require => Package['argus-pep-server'],
      notify  => Service['argus-pepd'],
    }

    file {"/etc/grid-security/groupmapfile":
      ensure => present,
      owner => "root",
      group => "root",
      mode => '0644',
      content => $group_mapfile,
      require => Package['argus-pep-server'],
      notify  => Service['argus-pepd'],
    }

    file {"/etc/grid-security/voms-grid-mapfile":
      ensure => present,
      owner => "root",
      group => "root",
      mode => '0644',
      content => $voms_mapfile,
      require => Package['argus-pep-server'],
      notify  => Service['argus-pepd'],
    }

  } else {

    class {'vosupport':
      supported_vos => [atlas, cms, lhcb, alice, dteam, ops, 'vo.aleph.cern.ch', 'vo.delphi.cern.ch', 'vo.l3.cern.ch', 
                        'vo.opal.cern.ch', ilc, 'envirogrids.vo.eu-egee.org', geant4, na48, unosat, 'vo.gear.cern.ch',
                        'vo.sixt.cern.ch'], #prod.vo.eu-eela.eu: missing voms
      enable_mappings_for_service => 'ARGUS',
      enable_poolaccounts => false,
      enable_environment => false,
      enable_voms => true,
      enable_gridmapdir_for_group => "root",
    }

    if $bdii {
      File['/usr/share/argus/pap/conf/pap_authorization.ini','/usr/share/argus/pap/conf/pap-admin.properties','/etc/argus/pdp/pdp.ini','/usr/share/argus/pepd/conf/pepd.ini'] -> Class['vosupport'] -> Class['argus::bdii']
    }

  }

  #pepd service must be restarted when the gridmap files change
  File['/etc/grid-security/grid-mapfile','/etc/grid-security/voms-grid-mapfile','/etc/grid-security/groupmapfile']~>Service['argus-pepd']

}
