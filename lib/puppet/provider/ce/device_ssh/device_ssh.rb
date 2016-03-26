# encoding: utf-8
require 'net/netconf'
require 'net/telnet'
require_relative '/opt/puppetlabs/puppet/lib/ruby/gems/2.1.0/gems/net-ssh-2.9.2/lib/net/ssh/Stelnet-common.rb'

# puppet namespace
module Puppet
  #NetDev namespace
  module NetDev
	#CE namespace
	module CE
        
	  class Device
	    
		@@ssh_session = nil
		@@command_ssh_api = nil

		
		@@ssh_hostip = nil
		@@ssh_username = nil
		@@ssh_password = nil
		
		
		def self.ssh_session()
		  if (nil == @@ssh_session && nil!=@@ssh_hostip && nil!=@@ssh_username && nil!=@@ssh_password)
			ssh_session = Puppet::NetDev::CE::SshSession.new(@@ssh_hostip, @@ssh_username, @@ssh_password)
			@@ssh_session = ssh_session.connect			
			puts "create ssh session in normal way"
			
		  #Below should be deleted, just for testing "puppet resource XXX" commands
		  elsif (nil == @@ssh_session && nil==@@ssh_hostip && nil==@@ssh_username && nil==@@ssh_password)
			ssh_session_back = Puppet::NetDev::CE::SshSession.new('10.136.13.30', 'huawei', 'Admin@123')
			@@ssh_session = ssh_session_back.connect
			puts "create ssh session not in normal way"
		  end
		  
					
		  @@ssh_session
		end
		
		def self.set_ssh_ip(ssh_ipaddress)
		  @@ssh_hostip = ssh_ipaddress
		end
		
		def self.set_ssh_username(ssh_username)
		  @@ssh_username = ssh_username
		end
		
		def self.set_ssh_password(ssh_password)
		  @@ssh_password = ssh_password
		end
		
		
		#create Command_sshApi instance
		def self.command_ssh_api()
		  if nil == @@command_ssh_api
			@@command_ssh_api = Command_sshApi.new()
		  end
		  @@command_ssh_api		
		end
		
	  end
	  
	end
  end
end    
