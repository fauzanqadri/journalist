class ComputerDotOrg < Journalist::Driver::Base
  HOME_URL = "https://www.computer.org/portal/web/guest/home"
  LOGOUT_URL = "http://www.computer.org/portal/c/portal/logout"

  def login
    page = mechanize_agent.get(HOME_URL)
    login_page = page.link_with(text: "Login").click
    login_page.form_with(name: "_58_fm") do |f|
      f.field_with(name: "_58_login").value = @journal_account.username
      f.field_with(name: "_58_password").value = @journal_account.password
    end.submit
  end

  def logout
    mechanize_agent.get(LOGOUT_URL)
  end

  def session_valid?
    page = mechanize_agent.get(HOME_URL)
    link = page.link_with(text: "Control Panel")
    return true if link.present?
    return false
  end
end
