class argus (
  ){
  case $::operatingsystem {
    RedHat,SLC,SL:   {
      require bdii
      class {'argus::install':}
      class {'argus::config':}
      class {'argus::lemon':}
      class {'argus::firewall':}
      class {'argus::service':}
    }    
    default: {
      # nothing here yet
    }
  }
}
