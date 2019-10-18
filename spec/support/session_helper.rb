module SessionHelper
  def login(user, with_capybara: false)
    @current_user = user
    if with_capybara
      page.driver.remove_cookie('user_credentials')
      page.driver.set_cookie('user_credentials', "#{user.persistence_token}::#{user.id}")
    else
      cookies['user_credentials'] = "#{user.persistence_token}::#{user.id}"
    end
  end
end
