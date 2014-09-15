require "rails_helper"

def login_html
  File.read("spec/factories/crowdworks/login.html")
end

def stub_login_page
  stub_request(:get, Crowdworks::Client::LOGIN_URL)
  .to_return(body: login_html, headers: { "Content-Type" => "text/html" })
end

RSpec.describe Crowdworks do
  describe ".new" do
    it "returns object of Client" do
      expect(Crowdworks.new).to be_a(Crowdworks::Client)
    end
  end
end

RSpec.describe Crowdworks::Client do
  let(:client) { described_class.new }
  let(:agent) { client.agent }

  describe "#agent" do
    it "returns instance of Mechanize" do
      expect(agent).to be_a(Mechanize)
    end
  end

  describe "#login" do
    context "password is blank" do
      before do
        stub_login_page
      end

      it "raise error of Crowdworks::Error::PasswordNotFound" do
        expect { client.login("example@example.com", "") }.to raise_error(Crowdworks::Error::PasswordNotFound)
      end
    end

    context "login failed" do
      before do
        stub_login_page
        stub_request(:post, Crowdworks::Client::LOGIN_URL)
        .to_return(body: login_html, headers: { "Content-Type" => "text/html" })
      end

      it "raise error of Crowdworks::Error::LoginFailed" do
        expect { client.login("example@example.com", "hogehoge") }.to raise_error(Crowdworks::Error::LoginFailed)
      end
    end
  end
end
