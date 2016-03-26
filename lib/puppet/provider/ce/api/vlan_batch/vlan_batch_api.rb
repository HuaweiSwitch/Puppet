# encoding: utf-8

# puppet namespace
module Puppet
  #NetDev namespace
  module NetDev
	#CE namespace
	module CE
           
	  class VlanBatchApi < ApiBase
		def initialize()
		  super()
		end
		
		def vlan_batch(resource)
		  session = Puppet::NetDev::CE::Device.session
		  
		  # transform tagged_vlans into trunkVlans bitmap
		    vlan_bit = Array.new(1024,0)
            all_bits = Array.new(1024,0)
			
            for i in resource[:vlan_start]..resource[:vlan_end] do
                tagged_vlans = i
                j = tagged_vlans/4
                if tagged_vlans%4 == 0
                     all_bits[j]= all_bits[j] + 1
                end
		
		        if tagged_vlans%4 == 1
                    all_bits[j]= all_bits[j] + 2                  
                end
		
		        if tagged_vlans%4 == 2
                  all_bits[j]= all_bits[j] + 4
                end
		
		        if tagged_vlans%4 == 3
                  all_bits[j]= all_bits[j] + 8
                end
		
	            case all_bits[j]
        
                  when 0 
			
                     vlan_bit[j] = '0'
                
                  when 1 
            
                    vlan_bit[j] = '8'
            
                  when 2 
			
                    vlan_bit[j] = '4'
                
                  when 3 
            
                    vlan_bit[j] = 'C'	
				
                  when 4 
			
                    vlan_bit[j] = '2'
                
                  when 5 
            
                    vlan_bit[j] = 'A'
            
                  when 6 
			
                    vlan_bit[j] = '6'
                
                  when 7 
            
                    vlan_bit[j] = 'E'
				
			      when 8 
			
                    vlan_bit[j] = '1'
                
                  when 9 
            
                    vlan_bit[j] = '9'
            
                  when 10 
			
                    vlan_bit[j] = '5'
                
                  when 11 
            
                    vlan_bit[j] = 'D'	
				
                  when 12 
			
                    vlan_bit[j] = '3'
                
                  when 13 
            
                    vlan_bit[j] = 'B'
            
                  when 14 
			
                    vlan_bit[j] = '7'
                
                  when 15 
            
                    vlan_bit[j] = 'F'
                end
            end

            aa = vlan_bit.join	

           if resource[:ensure] == :present			
		  
		  create_vlan_batch_xml = '<rpc><execute-action xmlns="http://www.huawei.com/netconf/capability/base/1.0"><action><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><shVlanBatchCrt><vlans>' + "#{aa}" + ':'+"#{aa}" +'</vlans></shVlanBatchCrt></vlan></action></execute-action></rpc>'
		  
		  session.rpc.do_config(create_vlan_batch_xml)
		  
		   end
		    
		   if resource[:ensure] == :absent
		   
		   delete_vlan_batch_xml = '<rpc><execute-action xmlns="http://www.huawei.com/netconf/capability/base/1.0"><action><vlan xmlns="http://www.huawei.com/netconf/vrp" content-version="1.0" format-version="1.0"><shVlanBatchDel><vlans>' + "#{aa}" + ':'+"#{aa}" +'</vlans></shVlanBatchDel></vlan></action></execute-action></rpc>'
		  
		   session.rpc.do_config(delete_vlan_batch_xml)
		   
		   end
		end
		
		
	  end
	
    end
  end
end    

