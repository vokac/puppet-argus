class argus::centralbanning inherits params {
  file {"/etc/cron.d/centralbanning":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("argus/centralbanning.erb"),
  }
  exec {"/usr/bin/pap-admin enable-pap centralbanning && /usr/bin/pap-admin set-paps-order centralbanning default && /usr/bin/pap-admin refresh-cache centralbanning":
    require => File["/etc/cron.d/centralbanning"],
  }
}
