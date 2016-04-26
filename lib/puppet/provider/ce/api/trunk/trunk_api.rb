# encoding: utf-8

# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class TrunkApi < ApiBase
        def initialize
          super()
        end

        def get_trunk
          trunk_array = []
          session = Puppet::NetDev::CE::Device.session
          get_trunk_xml = '<rpc><get><filter type="subtree"><ethernet xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><ethernetIfs><ethernetIf><ifName></ifName><l2Attribute><linkType></linkType><pvid></pvid><trunkVlans></trunkVlans></l2Attribute></ethernetIf></ethernetIfs></ethernet></ifm></filter></get></rpc>'

          trunk_all = session.rpc.do_config(get_trunk_xml)
          trunk_elements = trunk_all.first_element_child.first_element_child
          trunk_elements.element_children.each do |trunk_elem|
            trunk_doc = Nokogiri::XML(trunk_elem.to_s)
            trunk_name = trunk_doc.xpath('/ethernetIf/ifName').text
            trunk_mode = trunk_doc.xpath('/ethernetIf/l2Attribute/linkType').text
            trunk_untagged_vlan = trunk_doc.xpath('/ethernetIf/l2Attribute/pvid').text
            trunk_tagged_vlan = trunk_doc.xpath('/ethernetIf/l2Attribute/trunkVlans').text

            property_hash = { ensure: :present }
            property_hash[:name] = trunk_name

            if trunk_mode == 'access'
              property_hash[:mode] = :access
            elsif trunk_mode == 'trunk'
              property_hash[:mode] = :trunk
            end

            property_hash[:untagged_vlan] = trunk_untagged_vlan if trunk_untagged_vlan

            if trunk_tagged_vlan

              # transform tagged_vlans into vlan ID array
              itrunk = trunk_tagged_vlan.to_i(16)
              ibtrunk = itrunk.to_s(2)
              ibtrunkcount = ibtrunk.length

              if ibtrunkcount < 4096
                for i in 1..4096 - ibtrunkcount do
                  ibtrunk = '0' + ibtrunk
                end
                 end

              bbtrunk = []
              n = 0
              for i in 0..4096
                if ibtrunk[i] == '1'
                  bbtrunk[n] = i.to_s
                  n += 1
                end
                    end

              property_hash[:tagged_vlans] = bbtrunk

            end

            property_hash[:ensure] = :present
            property_hash[:encapsulation] = :dot1q

            trunk_array << property_hash
          end

          trunk_array
          end

        def set_trunk(resource)
          session = Puppet::NetDev::CE::Device.session

          if resource[:mode] == :access

            set_trunk_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ethernet xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><ethernetIfs><ethernetIf operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName><l2Attribute><linkType>access</linkType><pvid>' + (resource[:untagged_vlan]).to_s + '</pvid></l2Attribute></ethernetIf></ethernetIfs></ethernet></config></edit-config></rpc>'
            end

          if resource[:mode] == :trunk

            # transform tagged_vlans into trunkVlans bitmap
            count = resource[:tagged_vlans].count
            vlan_bit = Array.new(1024, 0)
            all_bits = Array.new(1024, 0)

            for i in 0..count - 1 do
              tagged_vlans = resource[:tagged_vlans][i].to_i
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

            # delete tagged_vlans
            get_trunk_xml = '<rpc><get><filter type="subtree"><ethernet xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><ethernetIfs><ethernetIf><ifName>' + (resource[:name]).to_s + '</ifName><l2Attribute><linkType></linkType><pvid></pvid><trunkVlans></trunkVlans></l2Attribute></ethernetIf></ethernetIfs></ethernet></ifm></filter></get></rpc>'

            trunk = session.rpc.do_config(get_trunk_xml)
            trunk_element = trunk.first_element_child.first_element_child
            trunk_doc = Nokogiri::XML(trunk_element.element_children.to_s)
            trunk_mode = trunk_doc.xpath('/ethernetIf/l2Attribute/linkType').text
            if trunk_mode == 'trunk'
              trunk_tagged_vlan = trunk_doc.xpath('/ethernetIf/l2Attribute/trunkVlans').text

              ia = trunk_tagged_vlan.to_i(16)
              ib = aa.to_i(16)
              c = ia ^ ib
              d = c & ia
              dd = d.to_s(16).upcase
              ddcount = dd.length

              if ddcount < 1024
                for i in 1..1024 - ddcount do
                  dd = '0' + dd
                end

        end

              delete_trunk_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ethernet xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><ethernetIfs><ethernetIf operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName><l2Attribute><linkType>trunk</linkType><pvid>1</pvid><trunkVlans>' + aa.to_s + ':' + dd.to_s + '</trunkVlans></l2Attribute></ethernetIf></ethernetIfs></ethernet></config></edit-config></rpc>'

              session.rpc.do_config(delete_trunk_xml)

            end

            # add tagged_vlans

            set_trunk_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ethernet xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><ethernetIfs><ethernetIf operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName><l2Attribute><linkType>trunk</linkType><pvid>' + (resource[:untagged_vlan]).to_s + '</pvid><trunkVlans>' + aa.to_s + ':' + aa.to_s + '</trunkVlans></l2Attribute></ethernetIf></ethernetIfs></ethernet></config></edit-config></rpc>'
          end

          session.rpc.do_config(set_trunk_xml)
          end
        end
      end
  end
end
