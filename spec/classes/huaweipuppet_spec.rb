require 'spec_helper'

describe 'huaweipuppet', :type => :class do
  let :pre_condition do
    "
    include huaweipuppet
    include huaweipuppet::trunk1
    include huaweipuppet::trunk2
    include huaweipuppet::vlan1
    "
  end
  let :facts do
    {
      :osfamily               => 'Huawei',
      :operatingsystem        => 'Huawei',
    }
  end
  it { is_expected.to compile }
end
