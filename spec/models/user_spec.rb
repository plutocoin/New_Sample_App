require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example user", email: "user@example.com", password: "cartmen132", password_confirmation: "cartmen132")
  end
  subject {@user}
  pending "add some examples to (or delete) #{__FILE__}"

  it {should respond_to(:authenticate)}
  it {should respond_to(:admin)}
  it {should respond_to(:microposts)}
  it { should be_valid }
  it { should_not be_admin }
  it { should respond_to(:feed)}

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin}
  end

  describe "micropost associations" do

    before { @user.save}
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user:@user, created_at: 1.hour.ago)
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) {should include(newer_micropost)}
      its(:feed) {should include(older_micropost)}
      its(:feed) {should_not include(unfollowed_post)}
    end

  it "should have the right microposts in the right order" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
  end
end



