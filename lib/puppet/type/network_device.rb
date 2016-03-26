# encoding: utf-8

Puppet::Type.newtype(:network_device) do
  @doc = "Network device resource"
  
  # Parameters
  
  newparam(:name, :namevar=>true) do
    desc "The network device name"
  end  
  
  newparam(:ipaddress) do
    desc "The management IP address, e.g. 10.10.10.10"
  end  

  newparam(:username) do
    desc "The username to create a session"
  end

  newparam(:password) do
    desc "The password to create a session"
  end  
  

  
  # Properties 
  
  newproperty(:enable) do
    desc 'Enable the session'
	defaultto :true
    newvalues(:true, :false)
  end
  
end
