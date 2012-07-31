require 'spec_helper'

describe 'Sureties', js: true do
  context 'as authotized user' do
    let!(:org) { create(:organization) }
    let(:surety) { build(:surety, organization: org) }
    before do
      login
      visit new_surety_path
      within('#new_surety') do
        select surety.organization.name, from: 'Organization'
        click_button 'Create Surety'
      end
    end
    
    it 'should show profile page' do
      current_path.should == surety_path(Surety.last)
    end
  end
  
  context 'as admin user' do
    context 'listing' do
      let!(:sureties) { 3.times.map { create(:surety) } }
      before do
        login create(:admin_user)
        visit sureties_path
      end
      
      it 'should show sureties' do
        sureties.each do |surety|
          page.should have_css "#surety-#{surety.id}"
        end
      end
    end
    
    context 'creating surety' do
      let!(:org) { create(:organization) }
      let!(:user) { create(:user) }
      let(:surety) { build(:surety, organization: org, user: user) }
      
      before do
        login create(:admin_user)
        visit new_surety_path
        within('#new_surety') do
          select user.full_name, from: 'User'
          select surety.organization.name, from: 'Organization'
          click_button 'Create Surety'
        end
      end
      
      it 'should create surety for selected user' do
        surety.user.should have(1).sureties
      end
    end
    
    context 'approving surety' do
      let!(:surety) { create(:surety) }
      
      before do
        login create(:admin_user)
        visit surety_path(surety)
        click_link('activate')
      end
      
      it 'should activate surety' do
        within("#surety-#{surety.id}-status") do
          page.should have_content('active')
        end
      end
    end
    
    context 'declining surety' do
      let!(:surety) { create(:surety) }
      
      before do
        login create(:admin_user)
        visit surety_path(surety)
        click_link('decline')
      end
      
      it 'should activate surety' do
        within("#surety-#{surety.id}-status") do
          page.should have_content('declined')
        end
      end
    end
    
    context 'closing surety' do
      let!(:surety) { create(:active_surety) }
      
      before do
        login create(:admin_user)
        visit surety_path(surety)
        click_link('close')
      end
      
      it 'should activate surety' do
        within("#surety-#{surety.id}-status") do
          page.should have_content('closed')
        end
      end
    end
  end
end
