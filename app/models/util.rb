class Util
  def self.import(url=nil)
    url = "http://crowdsourcing.dev/exports?token=141ca9edeb8029308fsdf88h82uw8eur872098740wua8141ca9edeb802930asduf8aufi69393934sufs" unless url

    user_ids = {} #old_id => new_id

    require 'open-uri'
    html = open(url).read
    json = JSON.parse(html)
    
    json["users"].each do |usr|
      if User.where(email: usr["email"]).limit(1).present?
        user = User.find_by(email: usr["email"])
      else
        user = User.new(
          username: usr["email"].split("@").first,
          email: usr["email"],
          password:  Devise.friendly_token[0,20]
        )
        user.save
      end
      user_ids[usr["id"]] = user.id
    end
    json["projects"].each do |prj|
      next unless prj["name"]
      next if prj["issues"].count == 0
      project = Project.find_or_create_by(name: prj["name"])
      project.description = ""
      project.is_public = false
      project.save
      prj["members"].each do |mem|
        member = Member.find_or_create_by(
          project_id: project.id,
          user_id: user_ids[mem["user_id"].to_i],
          is_admin: mem["is_admin"]
        )
      end
      prj["issues"].each do |iss|
        puts iss["subject"]
        issue = Issue.find_or_create_by({
          project_id: project.id,
          subject:   iss["title"],
          author_id: user_ids[iss["user_id"].to_i]
        })
        issue.save
      end
    end
    puts "done"
  end
end
