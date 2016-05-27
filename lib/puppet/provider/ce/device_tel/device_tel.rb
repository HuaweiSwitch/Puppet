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
        attr_accessor :telnet_session
        attr_accessor :command_telnet_api

        attr_accessor :telnet_hostip
        attr_accessor :telnet_username
        attr_accessor :telnet_password

        # puts @@netconf_hostip
        # create a session to connect to device

        def self.telnet_session
          if nil == @telnet_session && nil != @telnet_hostip && nil != @telnet_username && nil != @telnet_password
            telnet_session = Puppet::NetDev::CE::TelnetSession.new(@telnet_hostip, @telnet_username, @telnet_password)
            @telnet_session = telnet_session.connect
            puts 'create telnet session in normal way'

          # Below should be deleted, just for testing "puppet resource XXX" commands
          elsif nil == @telnet_session && nil == @telnet_hostip && nil == @telnet_username && nil == @telnet_password
            telnet_session_back = Puppet::NetDev::CE::TelnetSession.new('10.136.13.30', 'huawei', 'Admin@123')
            @telnet_session = telnet_session_back.connect
            puts 'create telnet session not in normal way'
          end

          @telnet_session
        end

        def self.set_telnet_ip(telnet_ipaddress)
          @telnet_hostip = telnet_ipaddress
        end

        def self.set_telnet_username(telnet_username)
          @telnet_username = telnet_username
        end

        def self.set_telnet_password(telnet_password)
          @telnet_password = telnet_password
        end

        # create Command_telnetApi instance
        def self.command_telnet_api
          if nil == @command_telnet_api
            @command_telnet_api = Command_telnetApi.new
          end
          @command_telnet_api
        end
      end
    end
  end
end
