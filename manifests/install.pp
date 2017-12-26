class argus::install (
  $ensure = present,
  $selinux = true,
) {

  # it is possible to install just argus-authz metapackage that contains
  # all necessary argus packages as dependencies, but this puppet module
  # use individual packages as requirements during configuration phase
  package { [ 'argus-authz', 'argus-pap', 'argus-pdp', 'argus-pep-server' ]:
    ensure => $ensure,
  }

  # update SELinux policy
  if $selinux {
    package { selinux-policy-targeted-emi2-gridmapdir:
      ensure => $ensure,
    }
  }

  # policy packages necessary for AUTHN_PROFILE_PIP configuration
  package { [ 'ca_policy_igtf-classic', 'ca_policy_igtf-mics', 'ca_policy_igtf-slcs' ]:
    ensure => $ensure,
  }

}
