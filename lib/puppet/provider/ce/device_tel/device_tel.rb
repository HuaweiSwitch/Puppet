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
      class Device_tel
        private_class_method :new

        attr_accessor :telnet_hostip
        attr_accessor :telnet_username
        attr_accessor :telnet_password
        
        @@telnet_session     = nil
        @@tel_instance       = nil
        @@command_telnet_api = nil

        def self.telnet_session
          if nil == @@telnet_session && nil != @@tel_instance.telnet_hostip && nil != @@tel_instance.telnet_username && nil != @@tel_instance.telnet_password
           
            telnet_session = Puppet::NetDev::CE::TelnetSession.new(@@tel_instance.telnet_hostip, @@tel_instance.telnet_username, @@tel_instance.telnet_password)
            @@telnet_session = telnet_session.connect
            puts 'create telnet session in normal way'
            
          end

          @@telnet_session
        end

        def self.tel_instance(telnet_ipaddress, telnet_username, telnet_password)
          @@tel_instance ||= new(telnet_ipaddress, telnet_username, telnet_password)
        end

        def initialize(telnet_ipaddress, telnet_username, telnet_password)
          @telnet_hostip   = telnet_ipaddress
          @telnet_username = telnet_username
          @telnet_password = telnet_password
        end

        # create Command_telnetApi instance
        def self.command_telnet_api
          if nil == @@command_telnet_api
            @@command_telnet_api = Command_telnetApi.new
          end
          @@command_telnet_api
        end
      end
    end
  end
end
