# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/trunk/trunk_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_trunk).provide(:ce, :parent => Puppet::Provider::CE) do

  mk_resource_methods

  def self.instances 
	array = []
	trunks = Puppet::NetDev::CE::Device.trunk_api.get_trunk()
	trunks.each { |property_hash|
		array << new(property_hash)
	}

	return array
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
  
  def flush()
	Puppet::NetDev::CE::Device.trunk_api.set_trunk(resource)
	trunks = Puppet::NetDev::CE::Device.trunk_api.get_trunk()
	update(trunks)
  end
    
  def update(propertys = [])
	propertys.each { |property_hash|
	  if resource[:name] == property_hash[:name]
		@property_hash = property_hash
		break
	  end
	}
  end
  def exists?()
    @property_hash[:ensure] == :present
  end

  def create()
	
  end

  def destroy()
	
  end
  
end
