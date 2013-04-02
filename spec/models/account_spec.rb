require 'spec_helper'

describe Account do
  context 'factories', factory: true do
    it { create(:account) }
    it { create(:active_account) }
  end
end
