module AcceptanceHelper
  def sign_in(name)
    page.set_rack_session(username: name)
    create_cookie(:username, name)
  end

  def save_screenshot(name = nil)
    path = name || "screenshot-#{Time.now.utc.iso8601.delete('-:')}.png"
    page.save_screenshot path
  end

  # Opens test server (using launchy), authorize as user (if provided)
  # and wait for specified time (in seconds) until continue spec execution
  #
  # If you specify 0 as 'wait' you should manually resume spec execution.
  def visit_server(user: nil, wait: 2, path: '/')
    url = "http://192.168.60.101:#{Capybara.server_port}"
    url += path

    p "Visit server on: #{url}"

    if wait == 0
      p "Type any key to continue..."
      $stdin.gets
      p "Done."
    else
      sleep wait
    end
  end
end
