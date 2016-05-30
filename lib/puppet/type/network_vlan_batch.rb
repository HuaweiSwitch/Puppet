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

Puppet::Type.newtype(:network_vlan_batch) do
  @doc = "Manage VLAN's.  Layer-2 VLAN's are managed by this resource type."

  apply_to_all
  ensurable

  feature :describable, 'The ability to add a description to a VLAN.'

  # Parameters

  newparam(:name, namevar: true) do
    desc 'The VLAN batch ID, e.g. Batch 1'

    validate do |value|
      case value
      when String then super(value)
      else raise "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  # Properties (state management)

  newproperty(:vlan_start) do
    desc 'The VLAN batch start ID, e.g. 100'

    validate do |value|
      value = Integer(value)
      unless value.between?(1, 4095)
        raise "value #{value.inspect} is not between 1 and 4095"
      end
    end
  end

  newproperty(:vlan_end) do
    desc 'The VLAN batch end ID, e.g. 200'

    validate do |value|
      value = Integer(value)
      unless value.between?(1, 4095)
        raise "value #{value.inspect} is not between 1 and 4095"
      end
    end
  end
end
