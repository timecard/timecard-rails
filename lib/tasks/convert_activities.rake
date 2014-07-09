desc "Convert activities that owner_type is Project"
task :convert_activities do
  PublicActivity::Activity.where(owner_type: "Project").each do |project_activity|
    user_activity = PublicActivity::Activity.find_by(trackable_id: project_activity.trackable.id, owner_type: "User")
    user_activity.update(recipient: project_activity.owner)
    project_activity.destroy
  end
end
