require 'spec_helper'

describe Ability do
  before do
    create :group
  end

  describe '#definitions' do
    before do
      Ability.stub(:raw_definitions) { { "users" => ["show", "update"] } }
      Ability.redefine!
    end
    subject { Ability.definitions }

    it 'does contain 2 definitions' do
      subject.size.should == 2
    end

    it 'does contain definition for "show" "users"' do
      subject.should include(Ability::Definition.new(:show, :users))
    end
  end

  describe '#redefine' do
    before do
      Ability.stub(:raw_definitions) { { "users" => ["show", "update"] } }
      Ability.redefine!

      Ability.stub(:raw_definitions) { { "users" => ["show", "edit"] } }
      Ability.redefine!
    end
    subject { Ability.all.map(&:to_definition) }

    it 'does contain new ability' do
      subject.should include(Ability::Definition.new(:edit, :users))
    end

    it 'does not contain removed ability' do
      subject.should_not include(Ability::Definition.new(:update, :users))
    end

    it 'does contain old ability' do
      subject.should include(Ability::Definition.new(:show, :users))
    end
  end
end
