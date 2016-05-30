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
      class UserApi < ApiBase
        def initialize
          super()
        end

        def get_user
          user_array = []
          session = Puppet::NetDev::CE::Device.session

          get_user_xml = '<rpc><get><filter type="subtree"><aaa xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><lam><users><user><userName></userName><password></password></user></users></lam></aaa></filter></get></rpc>'

          user_all = session.rpc.do_config(get_user_xml)
          user_elements = user_all.first_element_child.first_element_child.first_element_child

          user_elements.element_children.each do |user_elem|
            user_doc = Nokogiri::XML(user_elem.to_s)
            username = user_doc.xpath('/user/userName').text

            property_hash = { ensure: :present }
            property_hash[:name] = username
            property_hash[:user] = username
            property_hash[:password] = '******'
            user_array << property_hash
          end

          user_array
           end

        def set_user(resource)
          session = Puppet::NetDev::CE::Device.session

          set_user_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><aaa xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><lam><users><user operation="merge"><userName>' + (resource[:name]).to_s + '</userName>'

          if resource[:password]
            set_user_xml += '<password>' + (resource[:password]).to_s + '</password>'
          end

          set_user_xml += '</user></users></lam></aaa></config></edit-config></rpc>'

          session.rpc.do_config(set_user_xml)
        end

        # password is a must to create a new user
        def create_user(resource)
          session = Puppet::NetDev::CE::Device.session

          set_user_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><aaa xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><lam><users><user operation="merge"><userName>' + (resource[:name]).to_s + '</userName>'

          if resource[:password]
            set_user_xml += '<password>' + (resource[:password]).to_s + '</password>'
          end

          set_user_xml += '</user></users></lam></aaa></config></edit-config></rpc>'

          session.rpc.do_config(set_user_xml)
        end

        def delete_user(resource)
          session = Puppet::NetDev::CE::Device.session

          delete_user_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><aaa xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><lam><users><user operation="delete"><userName>' + (resource[:name]).to_s + '</userName></user></users></lam></aaa></config></edit-config></rpc>'

          session.rpc.do_config(delete_user_xml)
        end
      end
    end
  end
end
