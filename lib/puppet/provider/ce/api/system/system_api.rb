# encoding: utf-8

# puppet namespace
module Puppet
  #NetDev namespace
  module NetDev
	#CE namespace
	module CE
           
	  class SystemApi < ApiBase
		def initialize()
		  super()
		end
		
		def get_sysname
		  sysname_array = []
		  session = Puppet::NetDev::CE::Device.session
		  
		  get_sysname_xml = '<rpc><get><filter type="subtree"><system xmlns="http://www.huawei.com/netconf/vrp" format-version="1.0" content-version="1.0"><systemInfo><sysName></sysName></systemInfo></system></filter></get></rpc>'
		  
		  sysname_elem = session.rpc.do_config(get_sysname_xml).first_element_child.first_element_child
		  sysname_doc = Nokogiri::XML(sysname_elem.to_s)		  
		  sysname = sysname_doc.xpath("/systemInfo/sysName").text
		  
		  property_hash = {:name => sysname}
		  property_hash[:system_name] = sysname
		  sysname_array << property_hash
		  return sysname_array		  
		end
		
		def set_sysname(resource)
		  session = Puppet::NetDev::CE::Device.session
		  
		  set_sysname_xml = '<rpc><edit-config><target><running/></target><default-operation>merge</default-operation><error-option>rollback-on-error</error-option><config><system xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><systemInfo><sysName>' + "#{resource[:name]}" + '</sysName></systemInfo></system></config></edit-config></rpc>'
		  
		  session.rpc.do_config(set_sysname_xml)
		end

	  end
	
    end
  end
end    

