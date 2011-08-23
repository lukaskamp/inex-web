class Admin::UserController < Admin::AdminController
  
  active_scaffold :user do |config|
    config.columns = [:login, :password, :password_confirmation, :email]
    list.columns = [:login, :email, :created_at, :updated_at ]
    config.show.columns = [:login, :email, :created_at, :updated_at ]
  end
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

end
