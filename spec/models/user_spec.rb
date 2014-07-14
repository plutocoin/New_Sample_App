require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example user", email: "user@example.com", password: "cartmen132", password_confirmation: "cartmen132")
  end
  subject {@user}
  pending "add some examples to (or delete) #{__FILE__}"

  it {should respond_to(:authenticate)}
  it {should respond_to(:admin)}

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin}
  end
end




