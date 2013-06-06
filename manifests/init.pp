class argus (
  ){
  case $::operatingsystem {
    RedHat,SLC,SL:   {
      class {'argus::servicecert':}
      class {'argus::install':}
      class {'argus::config':}
      class {'argus::lemon':}
      class {'argus::bdii':}
      class {'argus::firewall':}
      class {'argus::service':}
    }    
    default: {
      # nothing here yet
    }
  }
}
