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
      class StackStatusApi < ApiBase
        def initialize
          super()
        end

        def get_stack_status
          stack_array = []
          
          session = Puppet::NetDev::CE::Device.session
          get_stack_status_xml = '<rpc><get><filter type="subtree"><stack xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><globalPara></globalPara></stack></filter></get></rpc>'
          stack_status_elem    = session.rpc.do_config(get_stack_status_xml).first_element_child.first_element_child
          stack_status_doc     = Nokogiri::XML(stack_status_elem.to_s)
          stack_status         = stack_status_doc.xpath('/globalPara/stackStatus').text
          stack_status_svf     = stack_status_doc.xpath('/globalPara/VstackStatus').text

          property_hash = { name: 'stack_status_check' }
          property_hash[:stack_status]     = stack_status
          property_hash[:stack_status_svf] = stack_status_svf
          
          stack_array << property_hash
          stack_array
        end
      end
    end
  end
end

