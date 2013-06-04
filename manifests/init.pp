class argus (
  ){
  case $::operatingsystem {
    RedHat,SLC,SL:   {
      include bdii
      class {'argus::servicecert':}
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
