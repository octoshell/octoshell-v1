require "spec_helper"
require "cancan/matchers"

describe Ability do
  subject { Ability.new(nil) }
  
  it { should be_able_to(:access, :all) }
end
