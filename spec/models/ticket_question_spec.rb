require 'spec_helper'

describe TicketQuestion do
  let(:ticket_question) { create(:ticket_question) }
  subject { ticket_question }
  
  it { should be }
  
  describe '#leaf' do
    context 'creating record with childs' do
      let!(:branch) { create(:ticket_question) }
      let!(:leaf) { build(:ticket_question) }
      
      before do
        leaf.ticket_question = branch
        leaf.save
      end
      
      it { branch.reload.should be_branch }
      it { leaf.reload.should be_leaf }
    end
    
    context 'updating record without childs' do
      let!(:leaf) { create(:leaf_ticket_question) }
      let!(:branch) { leaf.ticket_question }
      
      before do
        leaf.ticket_question = nil
        leaf.save
      end
      
      it { branch.reload.should be_leaf }
      it { leaf.reload.should be_leaf }
    end
    
    context 'changing parents' do
      let!(:leaf) { create(:leaf_ticket_question) }
      let!(:branch) { leaf.ticket_question }
      let!(:new_ticket_question) { create(:ticket_question) }
      
      before do
        leaf.ticket_question = new_ticket_question
        leaf.save
      end
      
      it { branch.reload.should be_leaf }
      it { leaf.reload.should be_leaf }
      it { new_ticket_question.reload.should be_branch }
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
