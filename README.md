# Overview

Puppet netdev module is the type specification for the Cloud Engine switches network functions. The module contains the CE specific Provider code which implements the defined types.

## Available functions:

- network_device
- network_interface
- network_l3_interface
- network_system_name
- network_trunk
- network_user
- network_vlan
- network_vlan_batch
- port_channel
- network_car
- network_diffserv
- network_qos_queue
- network_fan
- network_version
- network_board_status
- network_stack_status
- network_device_ssh
- network_command_ssh
- network_device_tel
- network_command_telnet

## Installation

- Circumstance instruction:  
Before taking the Puppet tool to manage devices, three softwares should be installed rightly, including Puppet module,Puppet master and Puppet agent. Puppet module must be installed on the Puppet master server, which can be downloaded from the [Puppetforge](https://forge.puppet.com/). At the same time, the netconf ruby gem is a required component of the netdev module, which can be downloaded from the [Rubygem](https://rubygems.org/). The tarball of Puppet master and agent can be download from [PuppetEnterprise:Download](https://puppet.com/download-puppet-enterprise).

- Main steps:  
  - [Install Puppet master](https://docs.puppet.com/pe/latest/quick_start_install_mono.html)
  - [Install Puppet module](https://docs.puppet.com/puppet/latest/modules_installing.html)
  - [Install Puppet agent](https://docs.puppet.com/pe/latest/install_huawei_ce.html)
  - [Install Ruby gems](https://rubygems.org/)

## Example usage

An example of static manifest for CE switch is followed. The network functions is satisfied based on the assumed that Puppet netdev module is available.

node 'CESwitch'{
    
	network_device{ $switch_model:
	name      => $switch-model,
	ipaddress => $Ethernet_ip,
	username  => $netconf_username,
	password  => $netconf_password,
	}
	
	network_vlan{'vlan200':
	ensure      => present,
	id          => 200,
	vlan_name   => 'vlan200',
	description => 'mkt vlan200', 
	require     => Network_device[$switch_model],
	}
	
	network_l3_interface{'Vlanif':
	ensure      => present,
	name        => 'Vlanif200',
	description => 'VLAN 200 L3 interface',
	enable      => 'true',
	ipaddress   => '192.168.10.1 255.255.255.0',
	require     => Network_device[$switch_model],
	}
		
	network_trunk{'10GE1/0/10':
	ensure        => present,
	name          => '10GE1/0/10',
	encapsulation => dot1q,
	mode          => 'access',
	untagged_vlan => 3, 
	require       => Network_device[$switch model],
	}
	
	port_channel{'Eth-Trunk1':
	ensure     => present,
	name       => 'Eth-Trunk1',   
	id         => '1',   
	mode       => disabled,   
	interfaces => ['10GE1/0/6','10GE1/0/7'],   
	require    => Network_device[$switch_model],
	}
	
	network_car{'car1':
	ensure         => present,
	name           => 'car1',
	interface_name => '10GE1/0/3',
	speed          => '500',
	require        => Network_device[$switch_model],
	}
}  

## References
[1] Puppet Enterprise
- [https://docs.puppetlabs.com/pe/latest/index.html](https://docs.puppetlabs.com/pe/latest/index.html)

[2] Based netdev module
- [https://forge.puppetlabs.com/puppetlabs/netdev_stdlib](https://forge.puppetlabs.com/puppetlabs/netdev_stdlib)   
