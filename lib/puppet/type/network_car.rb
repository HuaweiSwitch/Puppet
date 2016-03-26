# encoding: utf-8

Puppet::Type.newtype(:network_car) do

  apply_to_all
  ensurable

   # Parameters (additional data)

  newparam(:name, namevar: true) do
    desc 'Interface Name, e.g. Ethernet1'

    validate do |value|
      case value
      when String then super(value)
      else fail "value #{value.inspect} is invalid, must be a String."
      end
    end
  end
  
  
  # Properties (state management)

  
  newproperty(:interface_name) do

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else fail "value #{value.inspect} is invalid, must be a string."
      end
    end
  end


   newproperty(:speed) do

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else fail "value #{value.inspect} is invalid, must be a string."
      end
    end
  end
end
