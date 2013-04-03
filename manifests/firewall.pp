class argus::firewall inherits params{

  firewall { '101 allow argus pap':
    proto  => 'tcp',
    dport  => $pap_default_port,
    action => 'accept',
  }
  firewall { '101 allow argus pepd':
    proto  => 'tcp',
    dport  => $pepd_default_port,
    action => 'accept',
  }
}
