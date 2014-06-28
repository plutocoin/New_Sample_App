require 'spec_helper'

describe "StaticPages" do
  subject {page}
  let(:base_title) {"Ruby on Rails Tutorial Sample App" }
  describe "Home Page" do
    before { visit root_path }
    it { should have_content('Sample App')}
    it { should have_title("#{base_title} | Home")}
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
