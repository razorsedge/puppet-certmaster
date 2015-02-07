#!/usr/bin/env rspec

require 'spec_helper'

describe 'certmaster', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Unsupported platform: foo/)
      }
    end
  end

  context 'on a supported operatingsystem, default parameters' do
    let(:params) {{}}
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS'
    }
    end
    it { should contain_package('certmaster').with_ensure('present') }
    it { should contain_file('/etc/certmaster/minion.conf').with(
      :ensure => 'present',
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root'
    )}
    it 'should contain File[/etc/certmaster/minion.conf] with contents "certmaster = certmaster"' do
      verify_contents(catalogue, '/etc/certmaster/minion.conf', [ 'certmaster = certmaster', ])
    end
    it { should contain_file('/etc/certmaster/certmaster.conf').with(
      :ensure => 'present',
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root'
    )}
    it 'should contain File[/etc/certmaster/certmaster.conf] with contents "autosign = no" and "listen_addr = "' do
      verify_contents(catalogue, '/etc/certmaster/certmaster.conf', [
        'autosign = no',
        'listen_addr = ',
      ])
    end
    it { should contain_service('certmaster').with(
      :ensure     => 'stopped',
      :enable     => false,
      :hasrestart => true,
      :hasstatus  => false
    )}
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6'
    }
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent'
      }
      end
      it { should contain_package('certmaster').with_ensure('absent') }
      it { should contain_file('/etc/certmaster/minion.conf').with_ensure('absent') }
      it { should contain_file('/etc/certmaster/certmaster.conf').with_ensure('absent') }
      it { should contain_service('certmaster').with(
        :ensure => 'stopped',
        :enable => false
      )}
    end

    describe 'autoupgrade => true' do
      let :params do {
        :autoupgrade => true
      }
      end
      it { should contain_package('certmaster').with_ensure('latest') }
    end

    describe 'certmaster => localhost' do
      let :params do {
        :certmaster => 'localhost'
      }
      end
      it 'should contain File[/etc/certmaster/minion.conf] with contents "certmaster = localhost"' do
        verify_contents(catalogue, '/etc/certmaster/minion.conf', [ 'certmaster = localhost', ])
      end
    end

    describe 'listen_addr => 127.0.0.2' do
      let :params do {
        :listen_addr => '127.0.0.2'
      }
      end
      it 'should contain File[/etc/certmaster/certmaster.conf] with contents "listen_addr = 127.0.0.2"' do
        verify_contents(catalogue, '/etc/certmaster/certmaster.conf', [ 'listen_addr = 127.0.0.2', ])
      end
    end

    describe 'autosign => true' do
      let :params do {
        :autosign => true
      }
      end
      it 'should contain File[/etc/certmaster/certmaster.conf] with contents "autosign = yes"' do
        verify_contents(catalogue, '/etc/certmaster/certmaster.conf', [ 'autosign = yes', ])
      end
    end

    describe 'use_puppet_certs => true' do
      let :params do {
        :certmaster       => 'somehost',
        :use_puppet_certs => true
      }
      end
      it 'should contain File[/etc/certmaster/minion.conf] with contents "certmaster = "' do
        verify_contents(catalogue, '/etc/certmaster/minion.conf', [ 'certmaster = ', ])
      end
    end

    describe '$service_ensure => running; service_enable => true' do
      let :params do {
        :service_ensure => 'running',
        :service_enable => true
      }
      end
      it { should contain_service('certmaster').with(
        :ensure => 'running',
        :enable => true
      )}
    end
  end

end
