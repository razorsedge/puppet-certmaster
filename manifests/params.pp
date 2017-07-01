# == Class: certmaster::params
#
# This class handles OS-specific configuration of the certmaster module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class certmaster::params {

### The following parameters should not need to be changed.

  $certmaster_listen_addr = getvar('::certmaster_listen_addr')
  if $certmaster_listen_addr {
    $listen_addr = $::certmaster_listen_addr
  } else {
    $listen_addr = '' # lint:ignore:empty_string_assignment
  }

  $certmaster_certmaster = getvar('::certmaster_certmaster')
  if $certmaster_certmaster {
    $certmaster = $::certmaster_certmaster
  } else {
    $certmaster = 'certmaster'
  }

  $certmaster_autosign = getvar('::certmaster_autosign')
  if $certmaster_autosign {
    $autosign = $::certmaster_autosign
  } else {
    $autosign = false
  }
  if is_string($autosign) {
    $safe_autosign = str2bool($autosign)
  } else {
    $safe_autosign = $autosign
  }

  $func_use_puppet_certs = getvar('::func_use_puppet_certs')
  if $func_use_puppet_certs {
    $use_puppet_certs = $::func_use_puppet_certs
  } else {
    $use_puppet_certs = false
  }
  if is_string($use_puppet_certs) {
    $safe_use_puppet_certs = str2bool($use_puppet_certs)
  } else {
    $safe_use_puppet_certs = $use_puppet_certs
  }

  ######################################################################

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $certmaster_ensure = getvar('::certmaster_ensure')
  if $certmaster_ensure {
    $ensure = $::certmaster_ensure
  } else {
    $ensure = 'present'
  }

  $certmaster_service_ensure = getvar('::certmaster_service_ensure')
  if $certmaster_service_ensure {
    $service_ensure = $::certmaster_service_ensure
  } else {
    $service_ensure = 'stopped'
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $certmaster_autoupgrade = getvar('::certmaster_autoupgrade')
  if $certmaster_autoupgrade {
    $autoupgrade = $::certmaster_autoupgrade
  } else {
    $autoupgrade = false
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $certmaster_service_enable = getvar('::certmaster_service_enable')
  if $certmaster_service_enable {
    $service_enable = $::certmaster_service_enable
  } else {
    $service_enable = false
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $certmaster_service_hasrestart = getvar('::certmaster_service_hasrestart')
  if $certmaster_service_hasrestart {
    $service_hasrestart = $::certmaster_service_hasrestart
  } else {
    $service_hasrestart = true
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  # RHEL certmaster init script does not have a functioning status
  $certmaster_service_hasstatus = getvar('::certmaster_service_hasstatus')
  if $certmaster_service_hasstatus {
    $service_hasstatus = $::certmaster_service_hasstatus
  } else {
    $service_hasstatus = false
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
