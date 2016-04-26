# encoding: utf-8

require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/system/system_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_system_name).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    systemname = Puppet::NetDev::CE::Device.system_api.get_sysname

    systemname.each do |property_hash|
      array << new(property_hash)
    end

    array
  end

  def flush
    Puppet::NetDev::CE::Device.system_api.set_sysname(resource)
    systemname = Puppet::NetDev::CE::Device.system_api.get_sysname
    update(systemname)
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
