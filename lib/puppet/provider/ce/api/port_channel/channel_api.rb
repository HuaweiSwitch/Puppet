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
      class ChannelApi < ApiBase
        def initialize
          super()
        end

        def get_channel
          channel_array = []
          session = Puppet::NetDev::CE::Device.session
          get_channel_xml = '<rpc><get><filter type="subtree"><ifmtrunk xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><TrunkIfs><TrunkIf><ifName></ifName><workMode/><TrunkMemberIfs><TrunkMemberIf><memberIfName/><memberIfState/></TrunkMemberIf></TrunkMemberIfs></TrunkIf></TrunkIfs></ifmtrunk></filter></get></rpc>'

          channel_all = session.rpc.do_config(get_channel_xml)
          if channel_all.element_children.count != 0
            channel_elements = channel_all.first_element_child.first_element_child
            channel_elements.element_children.each do |channel_elem|
              channel_doc = Nokogiri::XML(channel_elem.to_s)
              channel_name = channel_doc.xpath('/TrunkIf/ifName').text
              # channel_id = channel_doc.xpath("/TrunkIf/lagID").text
              channel_mode = channel_doc.xpath('/TrunkIf/workMode').text

              channel_interface = []
              i = 0
              channel_doc.xpath('/TrunkIf/TrunkMemberIfs/TrunkMemberIf/memberIfName').children.each do |memberifname|
                channel_interface[i] = memberifname.text
                i += 1
              end

              property_hash = { ensure: :present }
              property_hash[:name] = channel_name

              property_hash[:id] = channel_name[9..-1]

              if channel_mode == 'Manual'
                property_hash[:mode] = :disabled
              elsif channel_mode == 'Static'
                property_hash[:mode] = :passive
              elsif channel_mode == 'Dynamic'
                property_hash[:mode] = :active
              end

              property_hash[:interfaces] = channel_interface if channel_interface

              channel_array << property_hash
            end
         end
          channel_array
          end

        def set_channel(resource)
          session = Puppet::NetDev::CE::Device.session

          if resource[:mode] == :disabled
            channel_mode = 'Manual'
          elsif resource[:mode] == :passive
            channel_mode = 'Static'
          elsif resource[:mode] == :active
            channel_mode = 'Dynamic'
          end

          set_channel_mode_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ifmtrunk xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><TrunkIfs><TrunkIf operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName><workMode>' + channel_mode.to_s + '</workMode></TrunkIf></TrunkIfs></ifmtrunk></config></edit-config></rpc>'

          session.rpc.do_config(set_channel_mode_xml)

          get_channel_port_xml = '<rpc><get><filter type="subtree"><ifmtrunk xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><TrunkIfs><TrunkIf><ifName>' + (resource[:name]).to_s + '</ifName><TrunkMemberIfs><TrunkMemberIf><memberIfName/></TrunkMemberIf></TrunkMemberIfs></TrunkIf></TrunkIfs></ifmtrunk></filter></get></rpc>'

          channel_all = session.rpc.do_config(get_channel_port_xml)

          if channel_all.element_children.count != 0

            channel_element = channel_all.first_element_child.first_element_child
            channel_doc = Nokogiri::XML(channel_element.element_children.to_s)

            channel_interface = []
            i = 0
            channel_doc.xpath('/TrunkIf/TrunkMemberIfs/TrunkMemberIf/memberIfName').children.each do |memberifname|
              channel_interface[i] = memberifname.text
              i += 1
            end
            count = channel_interface.count

            delete_channel_port_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ifmtrunk xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><TrunkIfs><TrunkIf operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName><TrunkMemberIfs>'

            for i in 0..count - 1
              delete_channel_port_xml += '<TrunkMemberIf operation="delete"><memberIfName>' + (channel_interface[i]).to_s + '</memberIfName></TrunkMemberIf>'
            end

            delete_channel_port_xml += '</TrunkMemberIfs></TrunkIf></TrunkIfs></ifmtrunk></config></edit-config></rpc>'

            session.rpc.do_config(delete_channel_port_xml)
          end

          count = resource[:interfaces].count

          if count > 0 && !resource[:interfaces][0].empty?
            add_channel_port_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ifmtrunk xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><TrunkIfs><TrunkIf operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName><TrunkMemberIfs>'

            if resource[:interfaces]
              for i in 0..count - 1
                add_channel_port_xml += '<TrunkMemberIf operation="create"><memberIfName>' + (resource[:interfaces][i]).to_s + '</memberIfName></TrunkMemberIf>'
             end
            end

            add_channel_port_xml += '</TrunkMemberIfs></TrunkIf></TrunkIfs></ifmtrunk></config></edit-config></rpc>'

            session.rpc.do_config(add_channel_port_xml)

           end
      end

        def create_channel(resource)
          session = Puppet::NetDev::CE::Device.session

          create_channel_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ifm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><interfaces><interface operation="create"><ifName>' + (resource[:name]).to_s + '</ifName></interface></interfaces></ifm></config></edit-config></rpc>'

          session.rpc.do_config(create_channel_xml)
          end

        def delete_channel(resource)
          session = Puppet::NetDev::CE::Device.session

          get_channel_port_xml = '<rpc><get><filter type="subtree"><ifmtrunk xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><TrunkIfs><TrunkIf><ifName>' + (resource[:name]).to_s + '</ifName><TrunkMemberIfs><TrunkMemberIf><memberIfName/></TrunkMemberIf></TrunkMemberIfs></TrunkIf></TrunkIfs></ifmtrunk></filter></get></rpc>'

          channel_all = session.rpc.do_config(get_channel_port_xml)

          if channel_all.element_children.count != 0

            channel_element = channel_all.first_element_child.first_element_child
            channel_doc = Nokogiri::XML(channel_element.element_children.to_s)

            channel_interface = []
            i = 0
            channel_doc.xpath('/TrunkIf/TrunkMemberIfs/TrunkMemberIf/memberIfName').children.each do |memberifname|
              channel_interface[i] = memberifname.text
              i += 1
            end
            count = channel_interface.count

            delete_channel_port_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ifmtrunk xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><TrunkIfs><TrunkIf operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName><TrunkMemberIfs>'

            for i in 0..count - 1
              delete_channel_port_xml += '<TrunkMemberIf operation="delete"><memberIfName>' + (channel_interface[i]).to_s + '</memberIfName></TrunkMemberIf>'
            end

            delete_channel_port_xml += '</TrunkMemberIfs></TrunkIf></TrunkIfs></ifmtrunk></config></edit-config></rpc>'

            session.rpc.do_config(delete_channel_port_xml)
          end

          delete_channel_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ifm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><interfaces><interface operation="delete"><ifName>' + (resource[:name]).to_s + '</ifName></interface></interfaces></ifm></config></edit-config></rpc>'

          session.rpc.do_config(delete_channel_xml)
            end
      end
      end
  end
end
