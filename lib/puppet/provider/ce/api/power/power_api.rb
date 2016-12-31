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
      class PowerApi < ApiBase
        def initialize
          super()
        end

        def get_power_status
          power_array     = []
          power_name      = nil
          operate_state   = nil
          
          session = Puppet::NetDev::CE::Device.session
          get_power_status_xml = '<rpc><get><filter type="subtree"><devm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><phyEntitys><phyEntity></phyEntity></phyEntitys></devm></filter></get></rpc>'
          power_status_elem    = session.rpc.do_config(get_power_status_xml).first_element_child
          power_status_elem.element_children.each do |phyEntitys_element|
            phyEntitys_element.element_children.each do |phyEntity_element|
              phyEntity_doc    = Nokogiri::XML(phyEntity_element.to_s)
              power_name_temp  = phyEntity_doc.xpath('/phyEntity/entClass').text
              next unless power_name_temp == 'powerSupply'
              power_name       = power_name_temp
              operate_state    = phyEntity_doc.xpath('/phyEntity/entOperState').text
              break
            end
            
            next unless power_name == 'powerSupply'
            break
          end
          
          property_hash = { name: 'power_status_check' }
          property_hash[:power_name]     = power_name
          property_hash[:operate_state]  = operate_state
          
          power_array << property_hash
          power_array
        end
      end
    end
  end
end
