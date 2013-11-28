desc "Trim space for ProjectGithub#full_name"
task :trim_space_for_full_name do
  ProjectGithub.all.each do |pg|
    if pg.full_name.present?
      puts "Before: #{pg.full_name}"
      pg.full_name.gsub!(/[[:space:]]*/, "")
      pg.save
      puts "After: #{pg.full_name}"
    end
  end
end
