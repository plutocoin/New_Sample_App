require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example user", email: "user@example.com", password: "cartmen132", password_confirmation: "cartmen132")
  end

  subject{@user}
  it { should respond_to(:name)}
  it { should respond_to(:email)}
  it { should respond_to(:remember_token)}
  it { should respond_to(:password_digest)}
  it { should be_valid }

  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end

  describe "when name is not present" do
    before { @user.name = " "}
    it {should_not be_valid }
  end

  describe "when email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end

  describe "when the name is too long" do
    before {@user.name = "a" * 51}
    it {should_not be_valid}
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com user@foobar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.com]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it {should_not be_valid}
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) {"FoDeRjkL@gmail.com"}
    it "should have lowercase email" do
    @user.email = mixed_case_email
    @user.save
    expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end



  describe "when password is left blank" do
    it { should respond_to(:password)}
    it { should respond_to(:password_confirmation)}
    it { should respond_to(:authenticate) }
    before do
      @user = User.new(name: "Example", email: "user@example.org", password: " ", password_confirmation: " ")
    end
    it {should_not be_valid}
  end

  describe "when password doesn't match confirmation" do
    before do
      @user = User.new(name: "Example", email: "example@example.org", password: "something", password_confirmation: "mismatch")
    end
    it {should_not be_valid}
  end

  describe "with password that's too short" do
    before {@user.password = @user.password_confirmation = "a" * 5}
    it {should be_invalid}
  end

  describe "return value of authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by(email: @user.email)}

    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end
  end
end

describe "User Pages" do
  subject {page}

  describe "Signup page" do
    before {visit signup_path}
    it { should have_content("Sign up")}
    it { should have_title(full_title("Sign up"))}
  end

  describe "signup" do
    before {visit signup_path}
    let(:submit) {"Create my account"}

    describe "with invalid information" do
      it "should not create a user" do
        expect {click_button submit}.not_to change(User,:count)
      end
      describe "error should appear" do
        before {click_button submit}
      it {should have_content("error")}
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "example@example.org"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation", with: "foobar"
      end
      it "should create a user" do
        expect {click_button submit}.to change(User,:count).by(1)
      end

      describe "new users should be redirected to page with their name and success alert" do
        before {click_button submit}
        let(:user) {User.find_by(email: 'user@example.com')}
        it {should have_title(User.name)}
        it {should have_link("Sign out")}
        it {should have_selector('div.alert.alert-success', text: 'Welcome')}
      end

      describe "Followed by signout" do
        before {click_link "Sign out"}
        it {should have_link("Sign in")}
      end
    end
  end

describe "profile page" do
  let(:user) {FactoryGirl.create(:user)}
  before { visit user_path(user)}
  it { should have_content(user.name)}
  it { should have_title(user.name)}
end
end
