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
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/command_ssh/command_ssh_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_command_ssh).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    array
  end

  def initialize(resources)
    super(resources)
  end

  def flush
    return unless exists?
    Puppet::NetDev::CE::Device.command_ssh_api.command_ssh(resource)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_hash = { ensure: :present }
  end

  def destroy
    @property_hash = { ensure: :absent }
  end
end
