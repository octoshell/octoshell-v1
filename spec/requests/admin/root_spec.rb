require 'spec_helper'

describe 'Admin Root' do
  before do
    login create(:admin_user)
    visit admin_path
  end
  
  it 'should show admin dashboard page' do
    current_path.should == admin_dashboard_path
  end
end