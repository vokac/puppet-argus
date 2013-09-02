class argus (
  ){
  case $::operatingsystem {
    RedHat,SLC,SL:   {
      class {'argus::servicecert':}
      class {'argus::install':}
      class {'argus::config':}
      class {'argus::bdii':}
      class {'argus::firewall':}
      class {'argus::service':}
      
      #Workaround for https://ggus.eu/ws/ticket_info.php?ticket=96586 
      #Until java 1.7 u40 is available and fixes the problem, we need to set java 6 as the Java version for PEPD.
      #TODO: this should be undone when the problem is fixed. See GS-259 for details
      $java6_pkg="java-1.6.0-sun"
      $java6_path="/usr/lib/jvm/jre-1.6.0-sun.x86_64/bin/java"
      ensure_packages([$java6_pkg,])
      file_line { 'force java 6 for pepd':
        path => '/etc/sysconfig/argus-pepd',
        line => "JAVACMD='$java6_path'",
        require => Class['argus::install','argus::config'],
        notify => Service['argus-pepd'],
      }
    }    
    default: {
      # nothing here yet
    }
  }
}
