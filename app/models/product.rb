class Product < ApplicationRecord
  CATEGORIES = %w(FRUIT VEGGIE BERRY MEAT FISH GAME HERB)

  before_create :set_defaults

  belongs_to :basket, counter_cache: :items_count

  private

  def set_defaults
    self.name ||= Faker::Food.name
    self.icon_path ||= Faker::Food.icon
    self.category ||= CATEGORIES.sample
  end
end
