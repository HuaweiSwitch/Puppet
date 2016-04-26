# encoding: utf-8
require 'net/netconf'
require 'net/telnet'
require_relative '/opt/puppetlabs/puppet/lib/ruby/gems/2.1.0/gems/net-ssh-2.9.2/lib/net/ssh/Stelnet-common.rb'

# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class Device
        @@session = nil
        @@telnet_session = nil
        @@ssh_session = nil
        @@interface_api = nil
        @@l3_interface_api = nil
        @@vlan_api = nil
        @@user_api = nil
        @@system_api = nil
        @@trunk_api = nil
        @@channel_api = nil
        @@car_api = nil
        @@diffserv_api = nil
        @@vlan_batch_api = nil

        @@netconf_hostip = nil
        @@netconf_username = nil
        @@netconf_password = nil

        def self.session
          if nil == @@session && nil != @@netconf_hostip && nil != @@netconf_username && nil != @@netconf_password

            ssh_session = Puppet::NetDev::CE::Session.new(@@netconf_hostip, @@netconf_username, @@netconf_password)
            @@session = ssh_session.connect
            puts 'create session in normal way'

          # Below should be deleted, just for testing "puppet resource XXX" commands
          elsif nil == @@session && nil == @@netconf_hostip && nil == @@netconf_username && nil == @@netconf_password
            # ssh_session_back = Puppet::NetDev::CE::Session.new('10.136.68.123', 'rootDC', 'root_DC123')
            # @@session = ssh_session_back.connect
            puts 'create session not in normal way'
          end
          #

          @@session
        end

        def self.set_netconf_ip(netconf_ipaddress)
          @@netconf_hostip = netconf_ipaddress
        end

        def self.set_netconf_username(netconf_username)
          @@netconf_username = netconf_username
        end

        def self.set_netconf_password(netconf_password)
          @@netconf_password = netconf_password
        end

        # create InterfaceApi instance
        def self.interface_api
          @@interface_api = InterfaceApi.new if nil == @@interface_api
          @@interface_api
        end

        # create L3InterfaceApi instance
        def self.l3_interface_api
          @@l3_interface_api = L3InterfaceApi.new if nil == @@l3_interface_api
          @@l3_interface_api
        end

        # create VlanApi instance
        def self.vlan_api
          @@vlan_api = VlanApi.new if nil == @@vlan_api
          @@vlan_api
        end

        # create UserApi instance
        def self.user_api
          @@user_api = UserApi.new if nil == @@user_api
          @@user_api
        end

        # create SystemApi instance
        def self.system_api
          @@system_api = SystemApi.new if nil == @@system_api
          @@system_api
        end

        # create TrunkApi instance
        def self.trunk_api
          @@trunk_api = TrunkApi.new if nil == @@trunk_api
          @@trunk_api
        end

        # create ChannelApi instance
        def self.channel_api
          @@channel_api = ChannelApi.new if nil == @@channel_api
          @@channel_api
        end

        # create CarApi instance
        def self.car_api
          @@car_api = CarApi.new if nil == @@car_api
          @@car_api
        end

        # create DiffervApi instance
        def self.diffserv_api
          @@diffserv_api = DiffervApi.new if nil == @@diffserv_api
          @@diffserv_api
        end

        # create VlanBatchApi instance
        def self.vlan_batch_api
          @@vlan_batch_api = VlanBatchApi.new if nil == @@vlan_batch_api
          @@vlan_batch_api
        end
    end
    end
  end
end
