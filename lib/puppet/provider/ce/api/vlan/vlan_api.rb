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
      class VlanApi < ApiBase
        def initialize
          super()
        end

        def do_config_vlan(xml_str)
          rpc = Nokogiri::XML(xml_str).root
          @trans.rpc_exec(rpc)
        end

        def get_vlan
          vlan_array = []
          session = Puppet::NetDev::CE::Device.session

          get_vlan_xml = '<rpc><get><filter type="subtree"><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><vlans><vlan></vlan></vlans></vlan></filter></get></rpc>'
          vlan_all = session.rpc.do_config(get_vlan_xml)
          vlan_elements = vlan_all.first_element_child.first_element_child

          vlan_elements.element_children.each do |vlan_elem|
            vlan_doc   = Nokogiri::XML(vlan_elem.to_s)
            vlan_id    = vlan_doc.xpath('/vlan/vlanId').text
            vlan_name  = vlan_doc.xpath('/vlan/vlanName').text
            vlan_des   = vlan_doc.xpath('/vlan/vlanDesc').text

            property_hash = { ensure: :present }
            property_hash[:id] = vlan_id
            property_hash[:name] = property_hash[:id]
            property_hash[:vlan_name] = vlan_name
            property_hash[:description] = vlan_des

            vlan_array << property_hash
          end

          vlan_array
        end

        def set_vlan(resource)
          session = Puppet::NetDev::CE::Device.session

          set_vlan_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><vlans><vlan operation="merge"><vlanId>' + (resource[:id]).to_s + '</vlanId>'

          if resource[:vlan_name]
            set_vlan_xml += '<vlanName>' + (resource[:vlan_name]).to_s + '</vlanName>'
          end

          if resource[:description]
            set_vlan_xml += '<vlanDesc>' + (resource[:description]).to_s + '</vlanDesc>'
          end

          set_vlan_xml += '</vlan></vlans></vlan></config></edit-config></rpc>'

          session.rpc.do_config(set_vlan_xml)
        end

        def create_vlan(resource)
          session = Puppet::NetDev::CE::Device.session

          create_vlan_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><vlans><vlan operation="create"><vlanId>' + (resource[:id]).to_s + '</vlanId><vlanName/><vlanDesc/><vlanType>common</vlanType></vlan></vlans></vlan></config></edit-config></rpc>'

          session.rpc.do_config(create_vlan_xml)
        end

        def delete_vlan(resource)
          session = Puppet::NetDev::CE::Device.session

          delete_vlan_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><vlans><vlan operation="delete"><vlanId>' + (resource[:id]).to_s + '</vlanId></vlan></vlans></vlan></config></edit-config></rpc>'

          session.rpc.do_config(delete_vlan_xml)
        end
      end
      end
  end
end
