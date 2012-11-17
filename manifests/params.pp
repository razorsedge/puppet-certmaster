# == Class: certmaster::params
#
# This class handles OS-specific configuration of the certmaster module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class certmaster::params {

### The following parameters should not need to be changed.

  $listen_addr = $::certmaster_listen_addr ? {
    undef   => '',
    default => $::certmaster_listen_addr,
  }

  $certmaster = $::certmaster_certmaster ? {
    undef   => 'certmaster',
    default => $::certmaster_certmaster,
  }

  $autosign = $::certmaster_autosign ? {
    undef   => false,
    default => $::certmaster_autosign,
  }
  if is_string($autosign) {
    $safe_autosign = str2bool($autosign)
  } else {
    $safe_autosign = $autosign
  }

  ######################################################################

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $ensure = $::certmaster_ensure ? {
    undef   => 'present',
    default => $::certmaster_ensure,
  }

  $service_ensure = $::certmaster_service_ensure ? {
    undef   => 'stopped',
    default => $::certmaster_service_ensure,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::certmaster_autoupgrade ? {
    undef   => false,
    default => $::certmaster_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::certmaster_service_enable ? {
    undef   => false,
    default => $::certmaster_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $service_hasrestart = $::certmaster_service_hasrestart ? {
    undef   => true,
    default => $::certmaster_service_hasrestart,
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  # RHEL certmaster init script does not have a functioning status
  $service_hasstatus = $::certmaster_service_hasstatus ? {
    undef   => false,
    default => $::certmaster_service_hasstatus,
  }
  if is_string($service_hasstatus) {
    $safe_service_hasstatus = str2bool($service_hasstatus)
  } else {
    $safe_service_hasstatus = $service_hasstatus
  }

  case $::osfamily {
    'RedHat': {
      $package_name     = 'certmaster'
      $file_name        = '/etc/certmaster/minion.conf'
      $server_file_name = '/etc/certmaster/certmaster.conf'
      $service_name     = 'certmaster'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
