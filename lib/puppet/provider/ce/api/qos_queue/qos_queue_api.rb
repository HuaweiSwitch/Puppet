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
      class QosQueueApi < ApiBase
        def initialize
          super()
        end

        def get_qos_queue
          queue_array = []          
          get_qos_queue_xml =   '<rpc>' \
                                '<get>' \
                                '<filter type="subtree">' \
                                '<qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0">' \
                                    '<qosIfQoss>' \
                                        '<qosPortQueues>' \
                                            '<qosPortQueue>' \
                                                '<ifName/>' \
                                                '<queueId/>' \
                                                '<cir/>' \
                                                '<pir/>' \
                                                '<cbs/>' \
                                                '<pbs/>' \
                                            '</qosPortQueue>' \
                                        '</qosPortQueues>' \
                                    '</qosIfQoss>' \
                                '</qos>' \
                                '</filter>' \
                                '</get>' \
                                '</rpc>'

          session = Puppet::NetDev::CE::Device.session
          rpc_reply = session.rpc.do_config(get_qos_queue_xml)           
          if rpc_reply.first_element_child  != nil
            qosPortQueues_elem = rpc_reply.first_element_child.first_element_child.first_element_child  
            qosPortQueues_elem.element_children.each do |qosPortQueue_elem|
              qosPortQueue_doc = Nokogiri::XML(qosPortQueue_elem.to_s)

              property_hash                  = {ensure: :present}             
              property_hash[:interface_name] = qosPortQueue_doc.xpath('/qosPortQueue/ifName').text
              property_hash[:queue_id]       = qosPortQueue_doc.xpath('/qosPortQueue/queueId').text               
              property_hash[:queue_cir]      = qosPortQueue_doc.xpath('/qosPortQueue/cir').text     
           
              queue_array << property_hash
            end
          end          
          queue_array          
        end

        def set_qos_queue(resource)
          interface_state = nil            
          get_interface_state_xml =   '<rpc>' \
                                      '<get>' \
                                        '<filter type="subtree">' \
                                          '<ifm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0">' \
                                            '<interfaces>' \
                                              '<interface>' \
                                                '<ifName>' + resource[:interface_name] + '</ifName>' \
                                                '<ifAdminStatus/>' \
                                              '</interface>' \
                                            '</interfaces>' \
                                          '</ifm>' \
                                        '</filter>' \
                                      '</get>' \
                                    '</rpc>'

          set_qos_queue_xml =   '<rpc>' \
                                '<edit-config>' \
                                '<target><running/></target>' \
                                '<default-operation>merge</default-operation>' \
                                '<error-option>rollback-on-error</error-option>' \
                                '<config>' \
                                '<qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0">' \
                                    '<qosIfQoss>' \
                                        '<qosPortQueues>' \
                                            '<qosPortQueue operation="merge">' \
                                                '<ifName>' + resource[:interface_name] + '</ifName>' \
                                                '<queueId>' + resource[:queue_id] + '</queueId>' \
                                                '<cir>' + resource[:queue_cir] + '</cir>' \
                                            '</qosPortQueue>' \
                                        '</qosPortQueues>' \
                                    '</qosIfQoss>' \
                                '</qos>' \
                                '</config>' \
                                '</edit-config>' \
                                '</rpc>'

          session   = Puppet::NetDev::CE::Device.session
          rpc_reply = session.rpc.do_config(get_interface_state_xml)
          interface_state_elem  = rpc_reply.first_element_child.first_element_child.first_element_child
          interface_state_doc   = Nokogiri::XML(interface_state_elem.to_s)
          interface_state       = interface_state_doc.xpath('/interface/ifAdminStatus').text
          
          if interface_state == 'up'
            session.rpc.do_config(set_qos_queue_xml)
          else
            raise "[Warn]The interface state is down, waiting for the next time to set configure."
          end         
        end
        
        def delete_qos_queue(resource)
          delete_qos_queue_xml =   '<rpc>' \
                                   '<edit-config>' \
                                   '<target><running/></target>' \
                                   '<default-operation>merge</default-operation>' \
                                   '<error-option>rollback-on-error</error-option>' \
                                   '<config>' \
                                   '<qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0">' \
                                     '<qosIfQoss>' \
                                       '<qosPortQueues>' \
                                         '<qosPortQueue operation="delete">' \
                                             '<ifName>' + resource[:interface_name] + '</ifName>' \
                                             '<queueId>' + resource[:queue_id] + '</queueId>' \
                                          '</qosPortQueue>' \
                                        '</qosPortQueues>' \
                                     '</qosIfQoss>' \
                                   '</qos>' \
                                   '</config>' \
                                   '</edit-config>' \
                                   '</rpc>'

          session = Puppet::NetDev::CE::Device.session
          session.rpc.do_config(delete_qos_queue_xml)      
        end
      end
    end
  end
end

