require 'spec_helper'

describe Surety do
  describe 'factories', factory: true do
    it { factory!(:surety).should be }
    it { factory!(:generated_surety).should be }
    it { factory!(:confirmed_surety).should be }
    it { factory!(:active_surety).should be }
    it { factory!(:closed_surety).should be }
  end
  
  describe '#activate' do
    let!(:user) { create(:sured_user) }
    let!(:new_surety) { create(:generated_surety) }
    let!(:sm) { create(:surety_member, surety: new_surety, user: user) }
    
    before do
      user.sureties.first.close!
      new_surety.activate!
      user.reload
    end
    
    it 'sures user' do
      user.should be_sured
    end
  end
end
