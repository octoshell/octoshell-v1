require 'spec_helper'

describe 'Sureties', js: true do
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
        confirm_dialog
      end
      
      it 'should activate surety' do
        within("#surety-#{surety.id}-status") do
          page.should have_content('closed')
        end
      end
    end
  end
end
