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
      class Device_ssh

        @@ssh_session     = nil
        @@command_ssh_api = nil
        
        @@ssh_hostip      = nil
        @@ssh_username    = nil
        @@ssh_password    = nil
        
        def self.ssh_session
          if nil == @@ssh_session && nil != @@ssh_hostip && nil != @@ssh_username && nil != @@ssh_password

            ssh_session   = Puppet::NetDev::CE::SshSession.new(@@ssh_hostip, @@ssh_username, @@ssh_password)
            @@ssh_session = ssh_session.connect
            puts 'create ssh session in normal way'

          end

          @@ssh_session
        end

        def self.ssh_instance(ssh_ipaddress, ssh_username, ssh_password)
          @@ssh_hostip   = ssh_ipaddress
          @@ssh_username = ssh_username
          @@ssh_password = ssh_password
        end

        # create Command_sshApi instance
        def self.command_ssh_api
          @@command_ssh_api = Command_sshApi.new if nil == @@command_ssh_api
          @@command_ssh_api
        end
    end
    end
  end
end
