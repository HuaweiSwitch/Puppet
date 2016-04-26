# encoding: utf-8

# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class InterfaceApi < ApiBase
        def initialize
          super()
        end

        def get_interface
          interface_array = []
          session = Puppet::NetDev::CE::Device.session

          get_interface_xml = '<rpc><get><filter type="subtree"><ifm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><interfaces><interface><ifName></ifName><ifDescr></ifDescr><ifAdminStatus></ifAdminStatus></interface></interfaces></ifm></filter></get></rpc>'

          interface_all = session.rpc.do_config(get_interface_xml)
          interface_elements = interface_all.first_element_child.first_element_child

          interface_elements.element_children.each do |interface_elem|
            interface_doc = Nokogiri::XML(interface_elem.to_s)
            interface_name = interface_doc.xpath('/interface/ifName').text
            interface_des = interface_doc.xpath('/interface/ifDescr').text
            interface_enable = interface_doc.xpath('/interface/ifAdminStatus').text

            property_hash = {}
            property_hash[:name] = interface_name

            property_hash[:description] = interface_des if interface_des

            if interface_enable == 'up'
              property_hash[:enable] = :true
            elsif interface_enable == 'down'
              property_hash[:enable] = :false
            end

            interface_array << property_hash
          end

          interface_array
        end

        def set_interface(resource)
          session = Puppet::NetDev::CE::Device.session

          set_interface_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><ifm xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><interfaces><interface operation="merge"><ifName>' + (resource[:name]).to_s + '</ifName>'

          if resource[:description]
            set_interface_xml += '<ifDescr>' + (resource[:description]).to_s + '</ifDescr>'
          end

          if resource[:enable] == :true
            set_interface_xml += '<ifAdminStatus>up</ifAdminStatus>'
          end

          if resource[:enable] == :false
            set_interface_xml += '<ifAdminStatus>down</ifAdminStatus>'
          end

          set_interface_xml += '</interface></interfaces></ifm></config></edit-config></rpc>'

          session.rpc.do_config(set_interface_xml)
        end
    end
    end
  end
end
