require 'acceptance_helper'

feature 'disconnection', :js do
  let(:basket) { create(:basket) }

  scenario "user disconnected notification" do
    sign_in('john')
    visit baskets_path
    expect(page).to have_content "Welcome, john!"

    Capybara.using_session(:b) do
      sign_in('jack')
      visit baskets_path
      expect(page).to have_content "Welcome, jack!"
      page.evaluate_script "App.disconnect();"
    end

    expect(page).to have_content "jack disconnected"
  end

  scenario "on product page" do
    sign_in('john')
    visit baskets_path
    expect(page).to have_content "Welcome, john!"

    Capybara.using_session(:b) do
      sign_in('jack')
      visit basket_path(basket)
      expect(page).to have_content "Welcome, jack!"
      page.evaluate_script "App.disconnect();"
    end

    expect(page).to have_content "jack disconnected"
    expect(page).to have_content "jack left this basket page"
  end
end
