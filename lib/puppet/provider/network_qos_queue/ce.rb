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
require 'puppet/provider/ce/api/qos_queue/qos_queue_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_qos_queue).provide(:ce, parent: Puppet::Provider::CE) do
  desc 'Provider for network_qos_queue'
  
  mk_resource_methods

  def initialize(resources)
    super(resources)
  end

  def self.instances
    array     = []
    
    qos_queue = Puppet::NetDev::CE::Device.qos_queue_api.get_qos_queue    
    qos_queue.each do |property_hash|
      array << new(property_hash)
    end
    
    array
  end

  def self.prefetch(resources)
    qos_queue_instance = instances     
    resources.keys.each do |name|
      provider = qos_queue_instance.find {|qos_queue| qos_queue.interface_name == name}
      resources[name].provider = provider unless provider.nil?
    end    
  end

  def flush
    if @property_hash[:ensure] == :absent
      Puppet::NetDev::CE::Device.qos_queue_api.delete_qos_queue(resource)   
    else
      Puppet::NetDev::CE::Device.qos_queue_api.set_qos_queue(resource)
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_hash[:ensure] = :present
  end  
  
  def destroy
    @property_hash[:ensure] = :absent
  end  
end

