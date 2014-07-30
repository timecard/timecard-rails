require 'rails_helper'

describe Provider do
  describe ".github" do
    it "returns Github Client object" do
      expect(Provider.github("token").class).to be(Github::Client)
    end
  end

  describe ".ruffnote" do
    it "returns Github Client object" do
      expect(Provider.ruffnote("token").class).to be(OAuth2::AccessToken)
    end
  end
end
