# encoding: utf-8

Puppet::Type.newtype(:network_l3_interface) do
  @doc = 'Manage Layer 3 network interfaces, e.g. Vlanif1'

  apply_to_all
  ensurable
  
  
  # Parameters 

  newparam(:name, namevar: true) do
    desc 'Interface Name, e.g. Vlanif1'

    validate do |value|
      case value
      when String then super(value)
      else fail "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  # Properties 
  
  newproperty(:enable) do
    desc 'Enable the interface, true or false'
	
    newvalues(:true, :false)
  end
  
  newproperty(:description) do
    desc 'Interface description'

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else fail "value #{value.inspect} is invalid, must be a string."
      end
    end
  end
  
  newproperty(:ipaddress) do
    desc 'Interface IP address'

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
