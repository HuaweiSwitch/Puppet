# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/user/user_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_user).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    users = Puppet::NetDev::CE::Device.user_api.get_user

    users.each do |property_hash|
      array << new(property_hash)
    end

    array
  end

  def flush
    return unless exists?
    Puppet::NetDev::CE::Device.user_api.set_user(resource)
    users = Puppet::NetDev::CE::Device.user_api.get_user
    update(users)
  end

  def update(propertys = [])
    propertys.each do |property_hash|
      if resource[:name] == property_hash[:name]
        @property_hash = property_hash
        break
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    Puppet::NetDev::CE::Device.user_api.create_user(resource)
    @property_hash = { password: resource[:password], ensure: :present }
  end

  def destroy
    Puppet::NetDev::CE::Device.user_api.delete_user(resource)
    @property_hash = { password: resource[:password], ensure: :absent }
  end
end
