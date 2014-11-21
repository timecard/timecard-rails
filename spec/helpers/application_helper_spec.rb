require 'rails_helper'

describe ApplicationHelper do
  describe ".link_to_provider" do
    issue = Issue.new(
      subject: "subject",
      description: "description",
    )

    it "get empty issue" do
      expect(
        link_to_provider(issue)
      ).to eq("")
    end
  end

  describe ".markdown" do
    it "get markdown" do
      expect(
        markdown("# test")
      ).to eq("<h1>test</h1>\n")
    end

    it "get empty" do
      expect(
        markdown("")
      ).to eq("")
    end

    it "get ramdom data" do
      expect(
        markdown("\xb6]\x1f\x16\x80jdC\xc9\"\xd5\xb5\x85\xe9\x95|\x15E\x8e7\xcb\x8c\x9f3\x90-\x89\xa7\xa5\xd0\xc77\xb4\xeb\x0c\x1d}\xcc$\xb2\x89O\xc5\xb9\xc2C\xc0kDP\xf6\xe3=\xf3\xe6\x84\xa5\xbd\x12\xfc;\x1awL")
      ).to eq("<p>?]\u001F\u0016?jdC?&quot;յ??|\u0015E?7ˌ?3?-?????7??\f\u001D}?$??OŹ?C?kDP??=?愥?\u0012?;\u001AwL</p>\n")
    end
  end

  describe ".gravatar_url" do
    it "get gravatar url" do
      expect(
        gravatar_url("email@example.com")
      ).to eq("https://www.gravatar.com/avatar/5658ffccee7f0ebfda2b226238b1eb6e?s=50")
    end
  end

  describe ".calc_label_color" do
    it "calc github label color" do
      expect(
        calc_label_color("f29513")
      ).to eq("color:#333333;background-color:#f29513")
    end
  end
end
