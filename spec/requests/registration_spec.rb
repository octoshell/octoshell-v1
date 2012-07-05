# coding: utf-8
require 'spec_helper'

describe 'Registration' do
  context 'as non authotized user' do
    let(:user) { build(:user) }
    let!(:institute) { create(:institute) }
    
    def fill_base_fields
      fill_in 'user_email',                 with: user.email
      fill_in 'user_password',              with: user.password
      fill_in 'user_password_confirmation', with: user.password
      fill_in 'user_first_name',            with: user.first_name
      fill_in 'user_last_name',             with: user.last_name
    end
    
    context 'with existed institute' do
      before do
        visit new_user_path
        fill_base_fields
        select institute.name, from: 'user_institute_id'
        click_button 'user_submit'
      end

      it 'should create new user' do
        User.find_by_email(user.email).should be
      end
      
      it 'should assign selected institute' do
        User.find_by_email(user.email).institute.should == institute
      end
    end
    
    context 'with new institute' do
      before do
        visit new_user_path
        fill_base_fields
        fill_in 'user_new_institute_name', with: 'New Institute'
        select 'ВУС', from: 'user_new_institute_kind'
        click_button 'user_submit'
      end

      it 'should create new user' do
        User.find_by_email(user.email).should be
      end
      
      it 'should assign new institute' do
        User.find_by_email(user.email).institute.name.should == 'New Institute'
      end
    end
  end
  
  context 'as authotized user' do
    let(:user) { create(:user) }
    
    before do
      login(user)
      visit new_user_path
    end
    
    it 'should logout' do
      current_user.should be_nil
    end
    
    it 'should not change path' do
      current_path.should == new_user_path
    end
  end
end
