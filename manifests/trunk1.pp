class puppetlabs_netdev_stdlib_ce::trunk1{


network_trunk{'10GE1/0/9':
ensure       => present,
name         => '10GE1/0/9',
encapsulation => dot1q,
mode         => 'trunk',
untagged_vlan => 1,
tagged_vlans => [2,3],
require      => Network_device['CE-5850'],
}

port_channel{'Eth-Trunk2':
ensure    => present,
name      => 'Eth-Trunk2',
id        => '2',
mode      => disabled,
interfaces => ['10GE1/0/7','10GE1/0/8'],
require   => Network_device['CE-5850'],
}

network_system_name{'CE_PUPPET':
system_name => 'CE_PUPPET',
require    => Network_device['CE-5850'],
}


}
