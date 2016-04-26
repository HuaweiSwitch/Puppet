# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/diffserv/diffserv_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_diffserv).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    diffserv = Puppet::NetDev::CE::Device.diffserv_api.get_diffserv
    diffserv.each do |property_hash|
      array << new(property_hash)
    end

    array
  end

  def initialize(resources)
    super(resources)
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def flush
    return unless exists?
    Puppet::NetDev::CE::Device.diffserv_api.set_diffserv(resource)
    diffserv = Puppet::NetDev::CE::Device.diffserv_api.get_diffserv
    update(diffserv)
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
    Puppet::NetDev::CE::Device.diffserv_api.create_diffserv(resource)
    @property_hash = { ensure: :present }
  end

  def destroy
    Puppet::NetDev::CE::Device.diffserv_api.delete_diffserv(resource)
    @property_hash = { ensure: :absent }
  end
end
