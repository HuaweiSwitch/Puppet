# encoding: utf-8

class Puppet::Provider::CE < Puppet::Provider

  confine :operatingsystem => :CEOS
 
  def initialize(resources)
    super(resources)
  end

  def self.prefetch(resources)
    instances.each do |prov|
	  if resource = resources[prov.name]
	    resource.provider = prov
	  end
    end
  end

end
