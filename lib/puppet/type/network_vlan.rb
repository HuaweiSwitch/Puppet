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

Puppet::Type.newtype(:network_vlan) do
  @doc = "Manage VLAN's.  Layer-2 VLAN's are managed by this resource type."

  apply_to_all
  ensurable

  feature :describable, 'The ability to add a description to a VLAN.'

  # Parameters

  newparam(:id, namevar: true) do
    desc 'The VLAN ID, e.g. 100'

    # Make sure we have a string for the ID
    munge do |value|
      Integer(value).to_s
    end
  end

  # Properties (state management)

  newproperty(:vlan_name) do
    desc 'The VLAN name, e.g. VLAN100'

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else raise "value #{value.inspect} is invalid, must be a string."
      end
    end
  end

  newproperty(:shutdown) do
    desc 'VLAN shutdown if true, not shutdown if false'
    newvalues(:true, :false)
  end

  newproperty(:description, required_features: ['describable']) do
    desc "The VLAN Description, e.g. 'Engineering'"

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else raise "value #{value.inspect} is invalid, must be a string."
      end
    end
  end
end
