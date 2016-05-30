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

    class DiffervApi < ApiBase
    def initialize
      super()
    end
    
    def get_diffserv
      diffserv_array = []
      session = Puppet::NetDev::CE::Device.session
      
      get_diffserv_xml = '<rpc><get><filter type="subtree"><qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><qosDss><qosDs></qosDs></qosDss></qos></filter></get></rpc>'
      
      diffserv_all = session.rpc.do_config(get_diffserv_xml)
      diffserv_elements = diffserv_all.first_element_child.first_element_child
      diffserv_elements.element_children.each do |ds_elem|
        ds_doc = Nokogiri::XML(ds_elem.to_s)
        ds_name = ds_doc.xpath('/qosDs/dsName').text
        ds_bas = ds_doc.xpath('/qosDs/qosBas/qosBa')
        ds_bas_num = ds_bas.count
        ds_phbs = ds_doc.xpath('/qosDs/qosPhbs/qosPhb')
        ds_phbs_num = ds_phbs.count

        property_hash = { ensure: :present }
        property_hash[:name] = ds_name
      
        if (ds_bas_num + ds_phbs_num) > 0
        # rules set is empty now
          rules = []
        # put inbound rules into rules array
          if ds_bas_num > 0
            ds_bas.each do |node|
              ba_node = Nokogiri::XML(node.to_s)
              ba_type_t = ba_node.xpath('/qosBa/baType').text
              ba_type = '8021p' if ba_type_t == '8021p'
              ba_type = 'dscp' if ba_type_t == 'ipDscp'
              ba_type = 'exp' if ba_type_t == 'Exp'
              ba_value = ba_node.xpath('/qosBa/baValue').text
              ba_service_class = ba_node.xpath('/qosBa/serviceClass').text
              ba_color = ba_node.xpath('/qosBa/color').text
              ba_rule = ['inbound', ba_type, ba_value, ba_service_class, ba_color]
              rules << ba_rule
            end
          end
        
          # put outbound rules into rules array
          if ds_phbs_num > 0
            ds_phbs.each do |node|
              phb_node = Nokogiri::XML(node.to_s)
              phb_type_t = phb_node.xpath('/qosPhb/phbType').text
              phb_type = '8021p' if phb_type_t == '8021p'
              phb_type = 'dscp' if phb_type_t == 'ipDscp'
              phb_type = 'exp' if phb_type_t == 'Exp'
              phb_service_class = phb_node.xpath('/qosPhb/serviceClass').text
              phb_color = phb_node.xpath('/qosPhb/color').text
              phb_value = phb_node.xpath('/qosPhb/phbValue').text
              phb_rule = ['outbound', phb_type, phb_service_class, phb_color, phb_value]
              rules << phb_rule
            end
          end
          property_hash[:rule] = { 'in_out_rules' => rules }
        end
        diffserv_array << property_hash
      end
      diffserv_array
    end


    def set_diffserv(resource)
      
      session = Puppet::NetDev::CE::Device.session
      
      # (1)get old rule array, which is rules already in diffserv
      diffserv_array_old = []
      diffserv_array_old_all = get_diffserv
      diffserv_array_old_all.each do |node|
        next unless node[:name] == resource[:name]
          if !node[:rule].nil?
            diffserv_array_old_rulehash = node[:rule]
            if !diffserv_array_old_rulehash["in_out_rules"].nil?
              diffserv_array_old = diffserv_array_old_rulehash['in_out_rules']
            end
          end
      
          # (2)get rule array in manifest
          diffserv_array_new = []
          if !resource[:rule].nil?
            diffserv_array_new_rulehash = resource[:rule]
            # must notice the hash here is indexed by a string, not a :mask
            if !diffserv_array_new_rulehash["in_out_rules"].nil?
              diffserv_array_new = diffserv_array_new_rulehash['in_out_rules']
            end
          end
      
          # (3)check if each old rule is still in new rules set, if not , old rule should be deleted. should notice direction(inbound/outbound) when deleting old rule
          diffserv_array_old.each do |old_rule|
          # chech exist
            old_rule_exist = 0
            for new_rule in diffserv_array_new
              if new_rule == old_rule
                old_rule_exist = 1
                break
              end
            end
      
          # if not exist, delete it
          if old_rule_exist == 0
            if old_rule[0] == 'inbound'
              ba_type = '8021p' if old_rule[1] == '8021p'
              ba_type = 'ipDscp' if old_rule[1] == 'dscp'
              ba_type = 'Exp' if old_rule[1] == 'exp'
              ba_value = old_rule[2]
              delete_in_rule_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><qosDss><qosDs><dsName>' + (resource[:name]).to_s + '</dsName><qosBas><qosBa operation="delete"><baType>' + ba_type + '</baType><baValue>' + ba_value + '</baValue></qosBa></qosBas></qosDs></qosDss></qos></config></edit-config></rpc>'
              session.rpc.do_config(delete_in_rule_xml)
            end
        
            if old_rule[0] == 'outbound'
              phb_type = '8021p' if old_rule[1] == '8021p'
              phb_type = 'ipDscp' if old_rule[1] == 'dscp'
              phb_type = 'Exp' if old_rule[1] == 'exp'
              service_class = old_rule[2]
              color = old_rule[3]
              delete_out_rule_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><qosDss><qosDs><dsName>' + (resource[:name]).to_s + '</dsName><qosPhbs><qosPhb operation="delete"><phbType>' + phb_type + '</phbType><serviceClass>' + service_class + '</serviceClass><color>' + color + '</color></qosPhb></qosPhbs></qosDs></qosDss></qos></config></edit-config></rpc>'
              session.rpc.do_config(delete_out_rule_xml)
            end
      
        # (4)check if each new rule is in the old rules set, if not, new rule should be created. should notice direction(inbound/outbound) when creating new rule
        diffserv_array_new.each do |new_rule|
          new_rule_exist = 0
          for old_rule in diffserv_array_old
            if new_rule == old_rule
              new_rule_exist = 1
              break
            end
          end
      
      # if not exist, create it
      if new_rule_exist == 0
        if new_rule[0] == 'inbound'
          ba_type = '8021p' if new_rule[1] == '8021p'
          ba_type = 'ipDscp' if new_rule[1] == 'dscp'
          ba_type = 'Exp' if new_rule[1] == 'exp'
          ba_value = new_rule[2]
          service_class = new_rule[3]
          color = new_rule[4]
          create_in_rule_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><qosDss><qosDs operation="merge"><dsName>' + (resource[:name]).to_s + '</dsName><qosBas><qosBa operation="create"><baType>' + ba_type + '</baType><baValue>' + ba_value + '</baValue><serviceClass>' + service_class + '</serviceClass><color>' + color + '</color></qosBa></qosBas></qosDs></qosDss></qos></config></edit-config></rpc>'
          session.rpc.do_config(create_in_rule_xml)
        end

        if new_rule[0] == 'outbound'
          phb_type = '8021p' if new_rule[1] == '8021p'
          phb_type = 'ipDscp' if new_rule[1] == 'dscp'
          phb_type = 'Exp' if new_rule[1] == 'exp'
          service_class = new_rule[2]
          color = new_rule[3]
          phb_value = new_rule[4]
          create_out_rule_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><qosDss><qosDs operation="merge"><dsName>' + (resource[:name]).to_s + '</dsName><qosPhbs><qosPhb operation="create"><phbType>' + phb_type + '</phbType><serviceClass>' + service_class + '</serviceClass><color>' + color + '</color><phbValue>' + phb_value + '</phbValue></qosPhb></qosPhbs></qosDs></qosDss></qos></config></edit-config></rpc>'
          session.rpc.do_config(create_out_rule_xml)
        end
      end

    def create_diffserv(resource)
    
      session = Puppet::NetDev::CE::Device.session
      create_diffserv_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><qosDss><qosDs operation="create"><dsName>' + (resource[:name]).to_s + '</dsName></qosDs></qosDss></qos></config></edit-config></rpc>'
      session.rpc.do_config(create_diffserv_xml)
    
    end
    

     
    def delete_diffserv(resource)
     
      session = Puppet::NetDev::CE::Device.session
      delete_diffserv_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><qos xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><qosDss><qosDs operation="delete"><dsName>' + (resource[:name]).to_s + '</dsName></qosDs></qosDss></qos></config></edit-config></rpc>'
      session.rpc.do_config(delete_diffserv_xml)
       
    end
    
  end
  
  end
  end
end
