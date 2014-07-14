class ProjectGithub < Provider
  store_into :info do |a|
    full_name
  end
end
