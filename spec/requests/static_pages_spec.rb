require 'spec_helper'

describe "StaticPages" do
  subject {page}
  let(:base_title) {"Ruby on Rails Tutorial Sample App" }
  describe "Home Page" do
    before { visit root_path }
    it { should have_content('Sample App')}
    it { should have_title("#{base_title} | Home")}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user, content: "lorem ipsum")
        FactoryGirl.create(:micropost, user, content: "random random")
        sign_in user
        visit root_path
      end

      it "should render the users feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end
  describe "Help Page" do
    before { visit help_path}
    it { should have_content("Help")}
    it { should have_title("#{base_title} | Help")}
  end
  describe "About Page" do
    before{visit about_path}
    it { should have_content("About Us")}
    it { should have_title("#{base_title} | About Us")}
  end
  describe "Contact Us Page" do
    before{visit contact_path}
    it { should have_content("Contact Us")}
    it { should have_title("#{base_title} | Contact Us")}
    end
end
