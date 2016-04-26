# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/interface/interface_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_interface).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    interfaces = Puppet::NetDev::CE::Device.interface_api.get_interface

    interfaces.each do |property_hash|
      array << new(property_hash)
    end

    array
  end

  def flush
    Puppet::NetDev::CE::Device.interface_api.set_interface(resource)
    interfaces = Puppet::NetDev::CE::Device.interface_api.get_interface
    update(interfaces)
  end

  def update(propertys = [])
    propertys.each do |property_hash|
      if resource[:name] == property_hash[:name]
        @property_hash = property_hash
        break
      end
    end
  end
end
