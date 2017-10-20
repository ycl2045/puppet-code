require 'spec_helper'
describe 'health' do

  context 'with default values for all parameters' do
    it { should contain_class('health') }
  end
end
