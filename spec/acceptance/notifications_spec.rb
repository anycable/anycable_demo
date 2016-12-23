require 'acceptance_helper'

feature 'notifications', :js do
  context "multiple sessions" do
    before do
      Capybara.using_session(:a) do
        sign_in('john')
        visit baskets_path
      end

      Capybara.using_session(:b) do
        sign_in('jack')
        visit baskets_path
      end
    end

    scenario "all users see notifications" do
      ActionCable.server.broadcast "notifications", type: 'alert', data: 'Slow Connection!'
      ActionCable.server.broadcast "notifications_john", type: 'success', data: 'Hi, John!'
      ActionCable.server.broadcast "notifications_jack", type: 'success', data: 'Hi, Jack!'

      Capybara.using_session(:a) do
        expect(page).to have_content 'Slow Connection!'
        expect(page).to have_content 'Hi, John!'
        expect(page).not_to have_content 'Hi, Jack!'
      end

      Capybara.using_session(:b) do
        expect(page).to have_content 'Slow Connection!'
        expect(page).to have_content 'Hi, Jack!'
        expect(page).not_to have_content 'Hi, John!'
      end
    end
  end

  scenario "unsubscribe from notifications and subscribe again" do
    sign_in('john')
    visit baskets_path

    expect(page).to have_content 'Welcome, john!'

    ActionCable.server.broadcast "notifications", type: 'notice', data: 'Bla-bla'
    expect(page).to have_content 'Bla-bla'

    page.find("#notifications_btn").trigger('click')

    ActionCable.server.broadcast "notifications", type: 'notice', data: 'Are you here?'
    ActionCable.server.broadcast "notifications_john", type: 'success', data: 'Come back, John!'

    expect(page).not_to have_content 'Are you here?'
    expect(page).not_to have_content 'Come back, John!'

    # Ensure that the first notification disappeared
    expect(page).not_to have_content 'Welcome, john!'

    page.find("#notifications_btn").trigger('click')
    expect(page).to have_content 'Welcome, john!'

    ActionCable.server.broadcast "notifications", type: 'success', data: 'Hi, John!'
    expect(page).to have_content 'Hi, John!'
  end
end
