require 'acceptance_helper'

feature 'create basket', :js do
  context "as user" do
    before do
      sign_in('john')
      visit baskets_path
    end

    scenario 'creates basket' do
      page.find("#add_basket_btn").trigger('click')

      within "#basket_form" do
        fill_in 'Name', with: 'Test basket'
        fill_in 'Description', with: 'Test text'
        click_on 'Save'
      end

      expect(page).to have_content I18n.t('baskets.create.message')
      expect(page).to have_content 'Test basket'
      expect(page).to have_content 'Test text'
    end
  end

  context "multiple sessions" do
    scenario "all users see new basket in real-time" do
      Capybara.using_session(:a) do
        sign_in('john')
        visit baskets_path
      end

      Capybara.using_session(:b) do
        sign_in('jack')
        visit baskets_path
        expect(page).to have_content 'No baskets found('
      end

      Capybara.using_session(:a) do
        page.find("#add_basket_btn").trigger('click')

        within "#basket_form" do
          fill_in 'Name', with: 'Test basket'
          fill_in 'Description', with: 'Test text'
          click_on 'Save'
        end

        expect(page).to have_content I18n.t('baskets.create.message')
        expect(page).to have_content 'Test basket'
        expect(page).to have_content 'Test text'
      end

      Capybara.using_session(:b) do
        expect(page).to have_content 'Test basket'
        expect(page).to_not have_content 'No baskets found('
      end
    end
  end
end
