class ProjectGithub < Provider
  store_into :info do |a|
    id
    full_name
  end
end
