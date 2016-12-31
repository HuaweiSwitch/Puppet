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

Puppet::Type.newtype(:network_diffserv) do
  apply_to_all
  ensurable

  # Parameters (additional data)

  newparam(:name, namevar: true) do
    desc 'Diffserv Name, e.g. DS1'

    validate do |value|
      case value
      when String then super(value)
      else raise "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  # Properties (state management)

  newproperty(:rule) do
    validate do |value|
      case value
      when Hash
      # nothing
      else raise 'value is invalid, must be a Hash.'
      end
    end
  end
end

