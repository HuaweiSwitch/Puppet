class puppetlabs_netdev_stdlib_ce::vlan1{

network_vlan{'200':
ensure => present,
id => 200,
vlan_name => 'vlan200',
description => 'vlan 200',
require => Network_device['CE-5850'],
}

network_interface{'10GE1/0/1':
enable => 'true',
description => 'first portqqS',
require => Network_device['CE-5850'],
}

network_l3_interface{'Vlanif1':
description => 'VLAN 1 L3 interface',
enable => 'true',
ipaddress => '192.168.10.1 255.255.255.0',
require => Network_device['CE-5850'],
}

}
