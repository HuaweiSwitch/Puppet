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
