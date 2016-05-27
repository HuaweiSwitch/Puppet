# encoding: utf-8
require 'net/netconf'
require 'net/telnet'
require 'net/Stelnet-common'

# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class Device
        attr_accessor :ssh_session
        attr_accessor :command_ssh_api

        attr_accessor :ssh_hostip
        attr_accessor :ssh_username
        attr_accessor :ssh_password

        def self.ssh_session
          if nil == @ssh_session && nil != @ssh_hostip && nil != @ssh_username && nil != @ssh_password
            ssh_session = Puppet::NetDev::CE::SshSession.new(@ssh_hostip, @ssh_username, @ssh_password)
            @ssh_session = ssh_session.connect
            puts 'create ssh session in normal way'

          # Below should be deleted, just for testing "puppet resource XXX" commands
          elsif nil == @ssh_session && nil == @ssh_hostip && nil == @ssh_username && nil == @ssh_password
            ssh_session_back = Puppet::NetDev::CE::SshSession.new('10.136.13.30', 'huawei', 'Admin@123')
            @ssh_session = ssh_session_back.connect
            puts 'create ssh session not in normal way'
          end

          @ssh_session
        end

        def self.set_ssh_ip(ssh_ipaddress)
          @ssh_hostip = ssh_ipaddress
        end

        def self.set_ssh_username(ssh_username)
          @ssh_username = ssh_username
        end

        def self.set_ssh_password(ssh_password)
          @ssh_password = ssh_password
        end

        # create Command_sshApi instance
        def self.command_ssh_api
          @command_ssh_api = Command_sshApi.new if nil == @command_ssh_api
          @command_ssh_api
        end
    end
    end
  end
end
