require 'spec_helper'

class UserWithPrettyId < ActiveRecord::Base
  self.table_name = 'users'
  has_pretty_id
end

class UserWithLongerPrettyId < ActiveRecord::Base
  self.table_name = 'users'
  has_pretty_id length: 16
end

class UserWithUrlsafeBase64PrettyId < ActiveRecord::Base
  self.table_name = 'users'
  has_pretty_id method: :urlsafe_base64
end

class UserWithLongerUrlsafeBase64PrettyId < ActiveRecord::Base
  self.table_name = 'users'
  has_pretty_id method: :urlsafe_base64, length: 32
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
      UserWithPrettyId.stub(:rand).and_return(1, 2)
    end

    it 'prevents duplicates' do
      u = UserWithPrettyId.create
      expect(u.pretty_id).to eq 'cccccccc'
    end
  end

  describe 'method = pretty' do
    it 'assigns 8 characters' do
      u = UserWithPrettyId.new
      u.generate_pretty_id
      expect(u.pretty_id.length).to eq 8
    end

    it 'assigns longer ids' do
      u = UserWithLongerPrettyId.new
      u.generate_pretty_id
      expect(u.pretty_id.length).to eq 16
    end
  end

  describe 'method = urlsafe_base64' do
    it 'assigns ~21 characters' do
      u = UserWithUrlsafeBase64PrettyId.new
      u.generate_pretty_id
      expect(u.pretty_id.length).to eq be_within(1).of(21)
    end

    it 'assigns more characters' do
      u = UserWithLongerUrlsafeBase64PrettyId.new
      u.generate_pretty_id
      expect(u.pretty_id.length).to eq be_within(1).of(32)
    end
  end

  describe '#regenerate_pretty_id' do
    let(:user) { UserWithPrettyId.create }

    it 'regenerates' do
      expect {
        user.regenerate_pretty_id
      }.to change { user.pretty_id }
    end

    it 'does not call save' do
      expect(user).to_not receive(:save)
      user.regenerate_pretty_id
    end

    it 'has a dangerous counterpart' do
      expect(user).to receive(:save)
      user.regenerate_pretty_id!
    end
  end
end
