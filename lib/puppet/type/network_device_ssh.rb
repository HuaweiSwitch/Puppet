# encoding: utf-8

Puppet::Type.newtype(:network_device_ssh) do
  @doc = 'Network device resource'

  # Parameters

  newparam(:name, namevar: true) do
    desc 'The network device name'
  end

  newparam(:sship) do
    desc 'The management IP address, e.g. 10.10.10.10'
  end

  newparam(:sshuser) do
    desc 'The username to create a telnet session'
  end

  newparam(:sshpass) do
    desc 'The password to create a telnet session'
  end

  # Properties

  newproperty(:enable) do
    desc 'Enable the session'
    defaultto :true
    newvalues(:true, :false)
  end
end
