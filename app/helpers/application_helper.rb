module ApplicationHelper
  def still_online_users
    User.online.map(&:nickname).join(', ')
  end
end
