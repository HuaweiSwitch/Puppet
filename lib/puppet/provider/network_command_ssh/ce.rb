# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/command_ssh/command_ssh_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_command_ssh).provide(:ce, :parent => Puppet::Provider::CE) do

  mk_resource_methods

  def self.instances 

	array = []
	return array
  end

  def initialize(resources)
    super(resources)
  end
  
  def flush()
 
	return if !exists?()
	Puppet::NetDev::CE::Device.command_ssh_api.command_ssh(resource)

  end
    
  def exists?()
    @property_hash[:ensure] == :present
  end
 
  def create()
	@property_hash = {:ensure => :present}
  end

  def destroy()
	@property_hash = {:ensure => :absent}
  end
 
  
end
