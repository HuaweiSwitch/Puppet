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
# rubocop:disable Style/PredicateName

Puppet::Type.newtype(:network_trunk) do
  @doc = 'Ethernet logical (switch-port) interface.  Configures VLAN trunking.'

  apply_to_all
  ensurable

  newparam(:name, namevar: true) do
    desc 'The switch interface name, e.g. "Ethernet1"'

    validate do |value|
      case value
      when String then super(value)
      else raise "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  newproperty(:encapsulation) do
    desc 'The vlan-tagging encapsulation protocol, usually dot1q'
    newvalues(:dot1q, :isl, :negotiate, :none)
  end

  newproperty(:mode) do
    desc 'The L2 interface mode, enables or disables trunking'
    newvalues(:access, :trunk, :dynamic_auto, :dynamic_desirable)
  end

  newproperty(:untagged_vlan) do
    desc 'VLAN used for untagged VLAN traffic. a.k.a Native VLAN'

    validate do |value|
      value = Integer(value)
      unless value.between?(1, 4095)
        raise "value #{value.inspect} is not between 1 and 4095"
      end
    end
  end

  newproperty(:tagged_vlans, array_matching: :all) do
    desc 'Array of VLAN names used for tagged packets'

    validate do |value|
      value = Integer(value)
      unless value.between?(1, 4095)
        raise "value #{value.inspect} is not between 1 and 4095"
      end
    end

    # def insync?(is)
    # is.sort == @should.sort.map(&:to_s)
    # end

    def should_to_s(val)
      "[#{[*val].join(',')}]"
    end

    def is_to_s(val)
      "[#{[*val].join(',')}]"
    end
  end

  newproperty(:pruned_vlans, array_matching: :all) do
    desc 'Array of VLAN ID numbers used for VLAN pruning'

    validate do |value|
      unless value.between?(1, 4095)
        raise "value #{value.inspect} is not between 1 and 4095"
      end
    end

    def insync?(is)
      is.sort == @should.sort.map(&:to_s)
    end

    def should_to_s(val)
      "[#{[*val].join(',')}]"
    end

    def is_to_s(val)
      "[#{[*val].join(',')}]"
    end
  end
end
