# encoding: utf-8

Puppet::Type.newtype(:network_system_name) do
  @doc = 'Manage system name, e.g. CE-ToR-1'

  apply_to_all

  # Parameters

  newparam(:name, namevar: true) do
    desc 'System Name, e.g. CE5850-1'

    validate do |value|
      case value
      when String then super(value)
      else raise "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  # Properties
  newproperty(:system_name) do
    desc 'The system name'

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
