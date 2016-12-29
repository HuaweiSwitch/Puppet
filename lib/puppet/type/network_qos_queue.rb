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

Puppet::Type.newtype(:network_qos_queue) do
  @doc = 'Qos queue Resource.'

  apply_to_all
  ensurable

  # Parameters
  newparam(:interface_name, namevar: true) do
    desc 'The interface name. Valid values are String. e.g. 10GE1/0/1'

    validate do |value|
      raise "value #{value.inspect} is invalid, which must be a String." unless value.is_a? String
    end
  end

  newproperty(:queue_id, namevar: true) do
    desc 'The queue index. Valid values are in the range (0..7)'

    validate do |value|
      raise "value #{value.inspect} should range from 0 to 7." unless (0..7).include? value.to_i
    end
    
    munge do |value|
      Integer(value).to_s
    end
  end
  
  # Properties
  newproperty(:queue_cir) do
    desc 'The committed information rate. Valid values are in the range (64..100000000), kbit/s.'

    validate do |value|
      raise "value #{value.inspect} should range from 64 to 100000000." unless (value.is_a? Integer) && ((64..100000000).include? value.to_i)
    end
    
    munge do |value|
      Integer(value).to_s
    end
  end
end

