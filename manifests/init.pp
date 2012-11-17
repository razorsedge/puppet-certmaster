# == Class: certmaster
#
# This module handles installing and configuring a certmaster client and/or
# server.  By default the service will be disabled unless parameters are passed
# to start the service.
#
# === Parameters:
#
# [*certmaster*]
#   The certmaster that the client talks to.
#   Default: certmaster
#
# [*listen_addr*]
#   The IP address on which the master will listen.
#   Default: empty (ie all available interfaces)
#
# [*autosign*]
#   Whether to automatically sign certificate requests.
#   Default: false
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*package_name*]
#   Name of the package.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*file_name*]
#   Name of the client config file.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*server_file_name*]
#   Name of the server config file.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: stopped
#
# [*service_name*]
#   Name of the service
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_enable*]
#   Start service at boot.
#   Default: false
#
# [*service_hasrestart*]
#   Service has restart command.
#   Default: true
#
# [*service_hasstatus*]
#   Service has status command.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: true
#
# === Actions:
#
# Installs the certmaster package.
# Manages the certmaster.conf and minion.conf files.
# Stops the certmaster service unless the host is configured as the certmaster.
#
# === Sample Usage:
#
#   # clients
#   node default {
#     class { 'certmaster':
#       certmaster  => 'certmaster.example.com',
#       autoupgrade => true,
#     }
#   }
#
#   # master
#   node 'certmaster.example.com' {
#     class { 'certmaster':
#       autoupgrade    => true,
#       autosign       => false,  # Can be true to automatically sign certs.
#       listen_addr    => 'certmaster.example.com',
#       service_ensure => 'running',
#       service_enable => true,
#     }
#   }
#
# === Authors
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class certmaster (
  $certmaster         = $certmaster::params::certmaster,
  $listen_addr        = $certmaster::params::listen_addr,
  $autosign           = $certmaster::params::safe_autosign,
  $ensure             = $certmaster::params::ensure,
  $autoupgrade        = $certmaster::params::safe_autoupgrade,
  $package_name       = $certmaster::params::package_name,
  $file_name          = $certmaster::params::file_name,
  $server_file_name   = $certmaster::params::server_file_name,
  $service_ensure     = $certmaster::params::service_ensure,
  $service_name       = $certmaster::params::service_name,
  $service_enable     = $certmaster::params::safe_service_enable,
  $service_hasrestart = $certmaster::params::safe_service_hasrestart,
  $service_hasstatus  = $certmaster::params::service_hasstatus
) inherits certmaster::params {
  # Validate our booleans
  validate_bool($autosign)
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
      $file_ensure = 'present'
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { $package_name :
    ensure  => $package_ensure,
  }

  file { $file_name:
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('certmaster/minion.conf.erb'),
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  file { $server_file_name:
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('certmaster/certmaster.conf.erb'),
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  service { $service_name :
    ensure     => $service_ensure_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
    require    => Package[$package_name],
  }
}
