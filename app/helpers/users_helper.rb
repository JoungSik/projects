module UsersHelper
  def avatar(user)
    color = ("b6e3f4".to_i(16) + user.id * 100) % 16777216
    new_hex = color.to_s(16).rjust(6, "0")

    "https://api.dicebear.com/9.x/initials/svg?seed=#{user.email}&radius=50&backgroundColor=#{new_hex}"
  end
end
