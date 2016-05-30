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
      class Session
        def initialize(host, username, password)
          @host = host
          @username = username
          @password = password
          @session = nil
        end

        def connect
          login = { target: @host, username: @username, password: @password }
          @session = Netconf::SSH.new(login)
          @session.open
          @session
        end
         end

      class TelnetSession
        def initialize(host, username, password)
          @host = host
          @username = username
          @password = password
          @telnet = nil
        end

        def connect
          @telnet = Net::Telnet.new('Host' => @host, 'Timeout' => 10, 'Prompt' => /C:.*>/)

          sleep 3
          @telnet.write(@username + "\n")
          @telnet.write(@password + "\n")
          @telnet.write("n\n")
          @telnet
           end
      end
      class SshSession
        def initialize(host, username, password)
          @host = host
          @username = username
          @password = password
          @ssh = nil
        end

        def connect
          @para = { 'Host' => @host, 'Port' => 22, 'Username' => @username, 'Password' => @password, 'Timeout' => 30, 'Prompt' => /C:.*>/ }
          @ssh = Net::SSH::Telnet.new(@para)
          @ssh
        end
         end
    end
  end
end
