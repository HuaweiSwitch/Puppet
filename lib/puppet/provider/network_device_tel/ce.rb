# encoding: utf-8
require 'puppet/provider/ce/device_tel/device_tel.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_device_tel).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    array
  end

  def flush
    Puppet::NetDev::CE::Device.set_telnet_ip(resource[:telip])
    Puppet::NetDev::CE::Device.set_telnet_username(resource[:teluser])
    Puppet::NetDev::CE::Device.set_telnet_password(resource[:telpass])
  end
end
