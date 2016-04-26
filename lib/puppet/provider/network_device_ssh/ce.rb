# encoding: utf-8
require 'puppet/provider/ce/device_ssh/device_ssh.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_device_ssh).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    array
  end

  def flush
    Puppet::NetDev::CE::Device.set_ssh_ip(resource[:sship])
    Puppet::NetDev::CE::Device.set_ssh_username(resource[:sshuser])
    Puppet::NetDev::CE::Device.set_ssh_password(resource[:sshpass])
  end
end
