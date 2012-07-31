require 'spec_helper'

describe 'Memberships', js: true do
  describe 'creating' do
    let!(:organization) { create(:organization) }
    let!(:position_name) { create(:position_name) }
    let!(:user) { create(:user) }
    
    before do
      login user
      visit new_membership_path
      select organization.name, from: 'Organization'
      fill_in position_name.name, with: 'value'
      click_button 'Create Membership'
    end
    
    it 'should create a membership' do
      user.should have(1).memberships
    end
    
    it 'should create a position' do
      user.memberships.first.should have(1).positions
    end
  end
end
