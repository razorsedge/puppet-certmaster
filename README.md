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
        autoupgrade    => true,
        autosign       => false,  # Can be true to automatically sign certificates.
        listen_addr    => 'certmaster.example.com',
        service_ensure => 'running',
        service_enable => true,
      }
    }


Notes
-----

* None

Issues
------

* None

TODO
----

* None

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

