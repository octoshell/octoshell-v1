require 'spec_helper'

describe 'User State Workflow' do
  
  it 'becoming sured' do
    user = create(:user)
    user.should be_active
    
    surety = create(:surety, user: user)
    user.reload.should be_active
    
    membership = create(:membership, user: user)
    user.reload.should be_active
    
    surety.activate!
    
    user.reload.should be_sured
  end
  
  it 'becoming active by closing membership' do
    user = create(:sured_user)
    
    user.memberships.first.close!
    
    user.reload
    
    user.should be_active
  end
  
  it 'becoming active by closing surety' do
    user = create(:sured_user)
    
    user.sureties.first.close!
    
    user.reload
    
    user.should be_active
  end
end
