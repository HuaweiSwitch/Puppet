# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class puppetlabs_netdev_stdlib_ce::trunk2{


network_trunk{'10GE1/0/10':
ensure       => present,
name         => '10GE1/0/10',
encapsulation => dot1q,
mode         => 'trunk',
untagged_vlan => 1,
tagged_vlans => [4,5],
require      => Network_device['CE-5850'],
}

port_channel{'Eth-Trunk1':
ensure    => present,
name      => 'Eth-Trunk1',
id        => '1',
mode      => disabled,
interfaces => ['10GE1/0/6'],
require   => Network_device['CE-5850'],
}

}
