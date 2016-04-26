# encoding: utf-8
require 'puppet/provider/ce/device/device.rb'
require 'puppet/provider/ce/api/apibase.rb'
require 'puppet/provider/ce/api/command_telnet/command_telnet_api.rb'
require 'puppet/provider/ce/session/session.rb'
require 'puppet/provider/ce/ce/ce.rb'

Puppet::Type.type(:network_command_telnet).provide(:ce, parent: Puppet::Provider::CE) do
  mk_resource_methods

  def self.instances
    array = []
    array
  end

  def initialize(resources)
    super(resources)
  end

  def flush
    return unless exists?
    Puppet::NetDev::CE::Device.command_telnet_api.command_telnet(resource)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_hash = { ensure: :present }
  end

  def destroy
    @property_hash = { ensure: :absent }
  end
end
