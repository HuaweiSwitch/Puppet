class huaweipuppet::trunk2 {
  network_trunk { '10GE1/0/10':
    ensure        => present,
    name          => '10GE1/0/10',
    encapsulation => 'dot1q',
    mode          => 'trunk',
    untagged_vlan => 1,
    tagged_vlans  => [4,5],
    require       => Network_device['CE-5850'],
  }
  port_channel { 'Eth-Trunk1':
    ensure     => present,
    name       => 'Eth-Trunk1',
    id         => '1',
    mode       => 'disabled',
    interfaces => ['10GE1/0/6'],
    require    => Network_device['CE-5850'],
  }
}
