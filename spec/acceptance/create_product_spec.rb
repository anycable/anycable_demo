require 'acceptance_helper'

feature 'create product', :js do
  let(:basket) { create(:basket) }

  context "as user" do
    before do
      sign_in('john')
      visit basket_path(basket)
    end

    scenario 'creates product' do
      page.find("#add_product_btn").click

      within "#product_form" do
        fill_in 'Name', with: 'Test product'
        click_on 'Save'
      end

      expect(page).to have_content I18n.t('products.create.message')
      expect(page).to have_content 'Test product'
    end
  end

  context "multiple sessions" do
    scenario "all users see new product in real-time" do
      Capybara.using_session('first') do
        sign_in('john')
        visit basket_path(basket)
      end

      Capybara.using_session('second') do
        sign_in('jack')
        visit basket_path(basket)
      end

      Capybara.using_session('first') do
        page.find("#add_product_btn").click

        within "#product_form" do
          fill_in 'Name', with: 'Test product'
          click_on 'Save'
        end

        expect(page).to have_content I18n.t('products.create.message')
        expect(page).to have_content 'Test product'
      end

      Capybara.using_session('second') do
        expect(page).to have_content 'Test product'
      end
    end

    scenario "users on /baskets see basket count updates in real-time" do
      Capybara.using_session('first') do
        sign_in('john')
        visit basket_path(basket)
      end

      Capybara.using_session('second') do
        sign_in('jack')
        visit baskets_path
      end

      Capybara.using_session('second') do
        find("#basket_#{basket.id} .badge", text: 0, match: :prefer_exact)
      end

      Capybara.using_session('first') do
        page.find("#add_product_btn").click

        within "#product_form" do
          fill_in 'Name', with: 'Test product'
          click_on 'Save'
        end

        expect(page).to have_content I18n.t('products.create.message')
        expect(page).to have_content 'Test product'
      end

      Capybara.using_session('second') do
        find("#basket_#{basket.id} .badge", text: 1, match: :prefer_exact)
      end
    end
  end
end
