# coding: utf-8
require 'spec_helper'

describe 'Admin::Sureties' do
  describe 'listing' do
    let!(:surety) { create(:surety) }
    
    before do
      login create(:admin_user)
      visit admin_sureties_path
    end
    
    it 'should show sureties' do
      Surety.all.each do |surety|
        within('#sureties') do
          page.should have_content(surety.id)
        end
      end
    end
  end
  
  describe 'finding' do
    context 'existed record' do
      let!(:surety) { create(:surety) }
      
      before do
        login create(:admin_user)
        visit admin_sureties_path
        fill_in :id, with: surety.id
        click_button 'Найти'
      end
      
      it 'should redirect to admin surety path' do
        current_path.should == admin_surety_path(surety)
      end
    end
    
    context 'missing record' do
      before do
        login create(:admin_user)
        visit admin_sureties_path
        fill_in :id, with: 1
        click_button 'Найти'
      end
      
      it 'should return to index path' do
        current_path.should == admin_sureties_path
      end
    end
  end
  
  describe 'activating' do
    let(:surety) { create(:surety) }
    
    before do
      login create(:admin_user)
      visit admin_surety_path(surety)
      click_link Surety.human_state_event_name(:_activate)
    end
    
    it 'should activate surety' do
      surety.reload.should be_active
    end
  end
  
  describe 'declining' do
    let(:surety) { create(:surety) }
    
    before do
      login create(:admin_user)
      visit admin_surety_path(surety)
      click_link Surety.human_state_event_name(:_decline)
    end
    
    it 'should decline surety' do
      surety.reload.should be_declined
    end
  end
  
  describe 'canceling' do
    let(:surety) { create(:active_surety) }
    
    before do
      login create(:admin_user)
      visit admin_surety_path(surety)
      click_link Surety.human_state_event_name(:_cancel)
    end
    
    it 'should decline surety' do
      surety.reload.should be_canceled
    end
  end
end
