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

Puppet::Type.newtype(:network_version) do

  @doc = 'The resource of checking the version of software and firmware.'

  apply_to_all

  # Parameters
  newparam(:name, namevar: true) do
    desc 'The name of checking version.'

    validate do |value|
      case value
      when String 
	    super(value)
      else 
	    raise "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  # Properties
  newproperty(:board_type, :readonly => true) do
    desc 'Show the type of board.'

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else 
	    raise "value #{value.inspect} is invalid, must be a string."
      end
    end
  end
  
  newproperty(:software_version, :readonly => true) do
    desc 'Show the current version of software.'

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else 
	    raise "value #{value.inspect} is invalid, must be a string."
      end
    end
  end
      
  newproperty(:firmware_version, :readonly => true) do
    desc 'Show the current version of firmware.'

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else 
	    raise "value #{value.inspect} is invalid, must be a string."
      end
    end
  end
end
