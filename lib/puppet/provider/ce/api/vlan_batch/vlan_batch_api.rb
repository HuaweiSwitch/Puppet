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

# encoding: utf-8

# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class VlanBatchApi < ApiBase
        def initialize
          super()
        end

        def vlan_batch(resource)
          session = Puppet::NetDev::CE::Device.session

          # transform tagged_vlans into trunkVlans bitmap
          vlan_bit = Array.new(1024, 0)
          all_bits = Array.new(1024, 0)

          for i in resource[:vlan_start]..resource[:vlan_end] do
            tagged_vlans = i
            j = tagged_vlans / 4
            all_bits[j] = all_bits[j] + 1 if tagged_vlans % 4 == 0

            all_bits[j] = all_bits[j] + 2 if tagged_vlans % 4 == 1

            all_bits[j] = all_bits[j] + 4 if tagged_vlans % 4 == 2

            all_bits[j] = all_bits[j] + 8 if tagged_vlans % 4 == 3

            case all_bits[j]

            when 0

              vlan_bit[j] = '0'

            when 1

              vlan_bit[j] = '8'

            when 2

              vlan_bit[j] = '4'

            when 3

              vlan_bit[j] = 'C'

            when 4

              vlan_bit[j] = '2'

            when 5

              vlan_bit[j] = 'A'

            when 6

              vlan_bit[j] = '6'

            when 7

              vlan_bit[j] = 'E'

            when 8

              vlan_bit[j] = '1'

            when 9

              vlan_bit[j] = '9'

            when 10

              vlan_bit[j] = '5'

            when 11

              vlan_bit[j] = 'D'

            when 12

              vlan_bit[j] = '3'

            when 13

              vlan_bit[j] = 'B'

            when 14

              vlan_bit[j] = '7'

            when 15

              vlan_bit[j] = 'F'
            end
          end

          aa = vlan_bit.join

          if resource[:ensure] == :present
            create_vlan_batch_xml = '<rpc><execute-action xmlns="http://www.huawei.com/netconf/capability/base/1.0"><action><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><shVlanBatchCrt><vlans>' + aa.to_s + ':' + aa.to_s + '</vlans></shVlanBatchCrt></vlan></action></execute-action></rpc>'
            session.rpc.do_config(create_vlan_batch_xml)
          end

          if resource[:ensure] == :absent
            delete_vlan_batch_xml = '<rpc><execute-action xmlns="http://www.huawei.com/netconf/capability/base/1.0"><action><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><shVlanBatchDel><vlans>' + aa.to_s + ':' + aa.to_s + '</vlans></shVlanBatchDel></vlan></action></execute-action></rpc>'
            session.rpc.do_config(delete_vlan_batch_xml)
          end
        end
      end
    end
  end
end
