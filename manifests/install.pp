class argus::install {
  package {emi-argus:
    ensure => present,
  }
  package { selinux-policy-targeted-emi2-gridmapdir:
    ensure => present,
  }   
}
