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
      #The default java version is Oracle 1.7 which does not contain the fix as of Sept 2013.  
      #Until Oracle java 1.7 u60 is available and fixes the problem, we need to use openjdk 1.7 >=2.3.10 as the Java version for PEPD.
      #TODO: this should be undone when the problem is fixed. See GS-259 for details
      $java_pkg="java-1.7.0-openjdk"
      $java_path="/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java"
      ensure_packages([$java_pkg,])
      file_line { 'force java openjdk 7 for pepd':
        path => '/etc/sysconfig/argus-pepd',
        line => "JAVACMD='$java_path'",
        match => '^\s*JAVACMD\s*=',
        require => [ Class['argus::install','argus::config'], Package[$java_pkg] ],
        notify => Service['argus-pepd'],
        loglevel => err,
      }
    }    
    default: {
      # nothing here yet
    }
  }
}
