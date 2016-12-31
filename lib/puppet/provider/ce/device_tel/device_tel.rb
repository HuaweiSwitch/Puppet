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

require 'net/telnet'

# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class Device_tel

        @@telnet_session     = nil
        @@command_telnet_api = nil
        
        @@telnet_hostip      = nil
        @@telnet_username    = nil
        @@telnet_password    = nil
        
        def self.telnet_session
          if nil == @@telnet_session && nil != @@telnet_hostip && nil != @@telnet_username && nil != @@telnet_password           
            telnet_session   = Puppet::NetDev::CE::TelnetSession.new(@@telnet_hostip, @@telnet_username, @@telnet_password)
            @@telnet_session = telnet_session.connect
            puts 'create telnet session in normal way'            
          end

          @@telnet_session
        end

        def self.tel_instance(telnet_ipaddress, telnet_username, telnet_password)
          @@telnet_hostip   = telnet_ipaddress
          @@telnet_username = telnet_username
          @@telnet_password = telnet_password
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

