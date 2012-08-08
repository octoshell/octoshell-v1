require 'spec_helper'

describe TicketQuestion do
  let(:ticket_question) { create(:ticket_question) }
  subject { ticket_question }
  
  it { should be }
  
  it { should belong_to(:ticket_question) }
  it { should have_many(:ticket_questions) }
  
  it { should validate_presence_of(:question) }
  
  describe '#leaf' do
    context 'saving record with childs' do
      let!(:branch) { create(:ticket_question) }
      let!(:leaf) { build(:ticket_question) }
      
      before do
        leaf.ticket_question = branch
        leaf.save
      end
      
      it { branch.reload.should be_branch }
      it { leaf.reload.should be_leaf }
    end
  end
  
  describe '#close' do
    let!(:leaf) { create(:leaf_ticket_question) }
    let!(:branch) { leaf.ticket_question }
    
    it { branch.should have(1).ticket_questions }
    
    context 'leaf' do
      before { leaf.reload.close }
      
      it { branch.reload.should be_leaf }
      it { leaf.should be_closed }
    end
    
    context 'branch' do
      before { branch.close }
      
      it { branch.should be_closed }
      it { branch.should be_leaf }
      it { leaf.reload.should be_closed }
    end
  end
end
