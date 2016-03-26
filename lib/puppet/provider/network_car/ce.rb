# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/car/car_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_car).provide(:ce, :parent => Puppet::Provider::CE) do

  mk_resource_methods

  def self.instances 
	array = []
	cars = Puppet::NetDev::CE::Device.car_api.get_car()
	cars.each { |property_hash|
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
	return if !exists?()
	Puppet::NetDev::CE::Device.car_api.set_car(resource)
	cars = Puppet::NetDev::CE::Device.car_api.get_car()
	update(cars)
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
	Puppet::NetDev::CE::Device.car_api.create_car(resource)
	@property_hash = {:ensure => :present}
  end

  def destroy()
	Puppet::NetDev::CE::Device.car_api.delete_car(resource)
	@property_hash = {:ensure => :absent}
  end
  
end
