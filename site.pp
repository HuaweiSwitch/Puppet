node 'default'{
    
  file{'/tmp/test.txt':
  content => "Huawei switch\n",
  }
  
  network_device{'CE-6850-HI':
  name      => 'CE-6850-HI' ,
  ipaddress => '100.0.0.1',
  username  => 'rootDC',
  password  => 'root_DC123',
  }
  
  network_vlan{'200':
  ensure      => present,
  id          => 200,
  vlan_name   => 'vlan200',
  description => 'mkt',
  require     => Network_device['CE-6850-HI'],
  }
}