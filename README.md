Certmaster Module
=================

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-certmaster.png?branch=master)](http://travis-ci.org/razorsedge/puppet-certmaster)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-certmaster.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-certmaster)

Introduction
------------

This module manages the installation and configuration of [certmaster](https://fedorahosted.org/certmaster/).
Certmaster is a set of tools and a library for easily distributing SSL certificates to applications that need them.

Actions:

* Installs the certmaster package.
* Manages the certmaster.conf and minion.conf files.
* Stops the certmaster service unless the host is configured as the certmaster.

OS Support:

* RedHat family - tested on CentOS 5.8+ and CentOS 6.3+
* Debian family - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

Normal Certmaster operation:

    # Top Scope variable (i.e. via Dashboard):
    $certmaster_certmaster = 'certmaster.example.com'
    $certmaster_autoupgrade = true
    include 'certmaster'


    # Parameterized Class:
    # clients
    node default {
      class { 'certmaster':
        certmaster  => 'certmaster.example.com',
        autoupgrade => true,
      }
    }

    # master
    node 'certmaster.example.com' {
      class { 'certmaster':
        certmaster     => 'certmaster.example.com',
        autoupgrade    => true,
        autosign       => false,  # Can be true to automatically sign certificates.
        listen_addr    => 'certmaster.example.com',
        service_ensure => 'running',
        service_enable => true,
      }
    }

Use Puppet certificates instead of Certmaster's:

    # Top Scope variable (i.e. via Dashboard):
    $certmaster_use_puppet_certs = true
    include 'certmaster'


    # Parameterized Class:
    # (There is no need to run the Certmaster daemon in this mode.)
    class { 'certmaster':
      use_puppet_certs => true,
    }


Notes
-----

* By default the certmaster service will be disabled as we assume most nodes will be clients.  Set service_ensure and service_enable to turn on the certmaster service.
* Requires [EPEL](http://fedoraproject.org/wiki/EPEL) for RedHat family hosts.

Issues
------

* None

TODO
----

* Add firewall support.

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

