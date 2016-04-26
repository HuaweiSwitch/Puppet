# encoding: utf-8

Puppet::Type.newtype(:network_user) do
  @doc = 'Users.'

  apply_to_all
  ensurable

  # feature :describable, 'The ability to add a description to a VLAN.'

  # Parameters
  newparam(:name, namevar: true) do
    desc 'The network user name'
  end

  # Properties (state management)

  newproperty(:user) do
    desc 'The user name'

    validate do |value|
      case value
      when String
        super(value)
        validate_features_per_value(value)
      else raise "value #{value.inspect} is invalid, must be a string."
      end
    end
  end

  newproperty(:password) do
    desc 'The password'

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
