class argus (
  $bdii                 = $argus::params::bdii,
  $selinux              = $argus::params::selinux,
  $firewall             = $argus::params::firewall,
  $use_vofiles          = $argus::params::use_vofiles,
  $use_hostcertificate  = $argus::params::use_hostcertificate,
) inherits argus::params {
  case $::operatingsystem {
    /RedHat|SLC|SL|Scientific|CentOS/:   {
      if $use_hostcertificate {
        class {'argus::servicecert':}
      }
      class { 'argus::install':
        selinux => $selinux,
      }
      class { 'argus::config':
        bdii => $bdii,
        use_vofiles => $use_vofiles,
      }
      if $bdii {
        class { 'argus::bdii':
          firewall => $firewall,
        }
      }
      if $firewall {
        class { 'argus::firewall': }
      }
      class { 'argus::service': }
    }
    default: {
      # nothing here yet
    }
  }
}
