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
      class BoardStatusApi < ApiBase
        def initialize
          super()
        end

        def get_board_status
          board_array     = []
          board_type      = nil
          operate_state   = nil
          standby_state   = nil
          board_type_list = ["mpuModule", "lpuModule", "sfuModule", "cmuModule"]
          
          session = Puppet::NetDev::CE::Device.session
          get_board_status_xml = '<rpc><get><filter type="subtree"><devm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><phyEntitys><phyEntity></phyEntity></phyEntitys></devm></filter></get></rpc>'
          board_status_elem    = session.rpc.do_config(get_board_status_xml).first_element_child
          board_status_elem.element_children.each do |phyEntitys_element|
            phyEntitys_element.element_children.each do |phyEntity_element|
              phyEntity_doc    = Nokogiri::XML(phyEntity_element.to_s)
              board_type_temp  = phyEntity_doc.xpath('/phyEntity/entClass').text
              temp_value       = board_type_list.include? board_type_temp
              next unless temp_value == true
              board_type       = board_type_temp
              operate_state    = phyEntity_doc.xpath('/phyEntity/entOperState').text
              standby_state    = phyEntity_doc.xpath('/phyEntity/entStandbyState').text
              break
            end
            
            next unless board_type != nil
            break
          end
          
          property_hash = { name: 'board_status_check' }
          property_hash[:board_type]      = board_type
          property_hash[:operate_state]   = operate_state
          property_hash[:standby_state]   = standby_state
          
          board_array << property_hash
          board_array
        end
      end
    end
  end
end

