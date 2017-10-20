require 'spec_helper'
describe 'idcos' do

  context 'with defaults for all parameters' do
    it { should contain_class('idcos') }
  end
end
