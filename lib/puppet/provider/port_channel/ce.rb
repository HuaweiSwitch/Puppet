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
require 'puppet/provider/ce/api/port_channel/channel_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:port_channel).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    channels = Puppet::NetDev::CE::Device.channel_api.get_channel
    channels.each do |property_hash|
      array << new(property_hash)
    end

    array
  end

  def initialize(resources)
    super(resources)
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def flush
    return unless exists?
    Puppet::NetDev::CE::Device.channel_api.set_channel(resource)
    channels = Puppet::NetDev::CE::Device.channel_api.get_channel
    update(channels)
  end

  def update(propertys = [])
    propertys.each do |property_hash|
      if resource[:name] == property_hash[:name]
        @property_hash = property_hash
        break
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    Puppet::NetDev::CE::Device.channel_api.create_channel(resource)
    @property_hash = { id: resource[:id], ensure: :present }
  end

  def destroy
    Puppet::NetDev::CE::Device.channel_api.delete_channel(resource)
    @property_hash = { id: resource[:id], ensure: :absent }
  end
end

