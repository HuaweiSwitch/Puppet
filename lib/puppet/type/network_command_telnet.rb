# encoding: utf-8

Puppet::Type.newtype(:network_command_telnet) do
  apply_to_all
  ensurable

  # Parameters (additional data)

  newparam(:name, namevar: true) do
    desc 'Command function Name, e.g. Ethernet1'

    validate do |value|
      case value
      when String then super(value)
      else raise "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  # Properties (state management)

  newproperty(:command, array_matching: :all) do
    validate do |value|
      case value
      when String
        super(value)
      else raise "value #{value.inspect} is invalid, must be a string."
      end
    end
  end
end
