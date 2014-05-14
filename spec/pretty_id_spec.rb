require 'spec_helper'

class UserWithPrettyId < ActiveRecord::Base
  self.table_name = 'users'
  has_pretty_id
end

class UserWithPrettyIdAlt < ActiveRecord::Base
  self.table_name = 'users'
  has_pretty_id column: :pretty_id_alt
end

describe PrettyId do
  it 'assigns before creation' do
    u = UserWithPrettyId.new
    expect(u.pretty_id).to be_nil
    u.save
    expect(u.pretty_id).to_not be_nil
  end

  it 'does not change' do
    u = UserWithPrettyId.create
    original_pretty_id = u.pretty_id
    u.update_attributes(pretty_id_alt: 'foo')
    expect(u.reload.pretty_id).to eq original_pretty_id
  end

  it 'can assign to other columns' do
    u = UserWithPrettyIdAlt.create
    expect(u.pretty_id).to be_blank
    expect(u.pretty_id_alt).to be_present
  end

  describe 'preventing duplicates' do
    before do
      UserWithPrettyId.stub(:exists?).and_return(true, false)
      UserWithPrettyId.any_instance.stub(:rand).and_return(1, 2)
    end

    it 'prevents duplicates' do
      u = UserWithPrettyId.create
      expect(u.pretty_id).to eq '2'
    end
  end
end
