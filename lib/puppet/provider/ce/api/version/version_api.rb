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
      class VersionApi < ApiBase
        def initialize
          super()
        end

        def get_version
          version_array    = []
          board_type       = nil
          software_version = nil
          firmware_version = nil
          
          session = Puppet::NetDev::CE::Device.session
          get_version_xml = '<rpc><get><filter type="subtree"><devm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><phyEntitys><phyEntity></phyEntity></phyEntitys></devm></filter></get></rpc>'
          version_elem    = session.rpc.do_config(get_version_xml).first_element_child
          version_elem.element_children.each do |phyEntitys_element|
            phyEntitys_element.element_children.each do |phyEntity_element|
              phyEntity_doc    = Nokogiri::XML(phyEntity_element.to_s)
              board_type_temp  = phyEntity_doc.xpath('/phyEntity/entClass').text
              next unless board_type_temp == 'mpuModule'
              board_type       = board_type_temp
              software_version = phyEntity_doc.xpath('/phyEntity/entSoftwareRev').text
              firmware_version = phyEntity_doc.xpath('/phyEntity/entFirmwareRev').text
              break
            end
            
            next unless board_type == 'mpuModule'
            break
          end
          
          property_hash = { name: 'version_check' }
          property_hash[:board_type]       = board_type
          property_hash[:software_version] = software_version
          property_hash[:firmware_version] = firmware_version
          
          version_array << property_hash
          version_array
        end
      end
    end
  end
end

