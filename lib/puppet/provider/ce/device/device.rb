# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

        @@session          = nil 
        @@telnet_session   = nil
        @@ssh_session      = nil
        
        @@netconf_hostip   = nil
        @@netconf_username = nil
        @@netconf_password = nil

        @@interface_api    = nil
        @@l3_interface_api = nil
        @@vlan_api         = nil
        @@user_api         = nil
        @@system_api       = nil
        @@trunk_api        = nil
        @@channel_api      = nil
        @@car_api          = nil
        @@diffserv_api     = nil
        @@vlan_batch_api   = nil

        def self.session
          if nil == @@session && nil != @@netconf_hostip && nil != @@netconf_username && nil != @@netconf_password

            ssh_session = Puppet::NetDev::CE::Session.new(@@netconf_hostip, @@netconf_username, @@netconf_password)
            @@session = ssh_session.connect
            puts 'create session in normal way'
            
          end

          @@session
        end

        def self.netconf_instance(netconf_ipaddress, netconf_username, netconf_password)
          @@netconf_hostip   = netconf_ipaddress
          @@netconf_username = netconf_username
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
