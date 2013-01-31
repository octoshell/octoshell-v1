# coding: utf-8
require 'spec_helper'

describe Mailer do
  before(:all) { I18n.locale = :ru }
  after(:all) { I18n.locale = MSU::Application.config.i18n.default_locale }
  
  describe '#project_blocked' do
    let(:project) { create(:project) }
    let(:account) { project.accounts.first }
    
    subject { Mailer.project_blocked(account) }
    
    its(:subject) { should == "Доступ к проекту #{project.name} заблокирован" }
    its(:to) { should include(account.user.email) }
  end
end
