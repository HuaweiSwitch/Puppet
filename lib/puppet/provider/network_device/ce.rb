# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_device).provide(:ce, :parent => Puppet::Provider::CE) do

  mk_resource_methods

  def self.instances
  	array = []
  	return array
  end
  
  def flush()		
	Puppet::NetDev::CE::Device.set_netconf_ip(resource[:ipaddress])
	Puppet::NetDev::CE::Device.set_netconf_username(resource[:username])
	Puppet::NetDev::CE::Device.set_netconf_password(resource[:password])
	
	
  end
  
end
