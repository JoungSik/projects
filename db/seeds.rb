# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

2.times do |i|
  user = User.create(name: "test #{i}", email: "test#{i}@test.com",
                     password: 'qwer1234', password_confirmation: 'qwer1234')

  2.times do |j|
    workspace = Workspace.create(name: "Workspace #{j}",
                                 workspace_users_attributes: { '0': { user: user, role: WorkspaceUser.roles[:owner] } })
    5.times do |k|
      project = Project.create(title: "Project #{j}#{k}", description: "Description #{j}#{k}",
                               workspace: workspace, owner: user, creator: user)

      10.times do |l|
        r = Random.new
        Task.create(title: "Task #{j}#{k}#{l}", description: "Description #{j}#{k}#{l}",
                    project: project, assign_user: user, creator: user,
                    start_at: Date.today - r.rand(0...4), end_at: Date.today + r.rand(0...4))
      end
    end
  end
end
