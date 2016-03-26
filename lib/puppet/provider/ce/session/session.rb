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
	
	  class Session
		def initialize(host, username, password)
		  @host = host
		  @username = username
		  @password = password
		  @session = nil
		end
		
		def connect()
		  login = { :target => @host, :username => @username, :password => @password }
		  @session = Netconf::SSH.new( login )
		  @session.open
		  @session
		end

	  end
	  
	  class TelnetSession
		def initialize(host, username, password)
		  @host = host
		  @username = username
		  @password = password
		  @telnet = nil
		end
		
		def connect()
		  @telnet = Net::Telnet::new("Host" => @host,"Timeout" => 10,"Prompt"=> /C:.*>/) 

		  sleep 3
          @telnet.write(@username+"\n")
          @telnet.write(@password+"\n") 
          @telnet.write("n\n")
		  @telnet

		end
		end
		 class SshSession
		def initialize(host, username, password)
		  @host = host
		  @username = username
		  @password = password
		  @ssh = nil
		end
		
		def connect()
		  @para = {"Host" => @host, "Port" => 22,"Username" => @username,"Password" => @password,"Timeout" => 30,"Prompt" => /C:.*>/}
          @ssh = Net::SSH::Telnet.new(@para)
          @ssh
		end

	  end
	  
	end
  end
end    

