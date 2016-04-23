require 'spec_helper'

describe 'huaweipuppet::trunk2', :type => :class do
  let :facts do
    {
      :osfamily               => 'Huawei',
      :operatingsystem        => 'Huawei',
    }
  end
  it { is_expected.to compile }
end
