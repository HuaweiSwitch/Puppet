Overview

Puppet netdev module is the type specification for the Cloud Engine switches network functions. The module contained the CE specific Provider code which implement the defined types.

Available functions:
 - network_interface
 - network_l3_interface
 - network_system_name
 - network_trunk
 - network_user
 - network_vlan
 - network_vlan_batch
 - port_channel
 - network_car
 - network_command_ssh
 - network_command_telnet
 - network_diffserv

Installation

Circumstance instruction:
Puppet netdev module is suitable for Puppet agent 1.3.6 which runs in lxc environment contained by CE switch.
Available Puppet master version is PE 2015.3. 

Main steps:
 - Install suitable puppet master.
 - Install CE switch with firmware which included lxc environment.
 - Install puppet agent in CE switch .
 - Synchronize the puppet netdev module.

Example usage

An example of static manifest for CE switch is followed. The network functions is satisfied based on the assumed that Puppet netdev module is available.

node 'CE Switch'{
    
	network_device{ $switch model:
	name => $switch model,
	ipaddress => $Ethernet ip,
	username => $netconf username,
	password => $netconf password,
	}
	
	network_l3_interface{'Vlanif1':
        ensure => present,
	name => 'Vlanif1',
	description => 'VLAN 1 L3 interface',
	enable => 'false',
	ipaddress => '192.168.10.1 255.255.255.0',
	require => Network_device[$switch model],
	}
	
	network_trunk{'10GE1/0/10':
	ensure => present,
	name => '10GE1/0/10',
	encapsulation => dot1q,
	mode => 'access',
        untagged_vlan => 3, 
	require => Network_device[$switch model],
    }
	
	port_channel{'Eth-Trunk1':
	ensure => present,
	name => 'Eth-Trunk1',
	id => '1',
	mode => disabled,
        interfaces => ['10GE1/0/6','10GE1/0/7'],	
	require => Network_device[$switch model],
    }
	
	network_vlan{'200':
	ensure => present,
	id => 200,
	vlan_name => 'vlan200',
        description => 'mkt', 
	require => Network_device[$switch model],
	}
    
	network_car{'car1':
	ensure => present,
	name => 'car1',
	interface_name => '10GE1/0/3',
	speed => '500',
        require => Network_device[$switch model],
    }
}  

References   
    [1] Puppet Enterprise   
        [https://docs.puppetlabs.com/pe/latest/index.html](https://docs.puppetlabs.com/pe/latest/index.html)   
    [2] Based netdev module   
        [https://forge.puppetlabs.com/puppetlabs/netdev_stdlib](https://forge.puppetlabs.com/puppetlabs/netdev_stdlib)   
