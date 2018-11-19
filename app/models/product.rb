require "faker/food"

class Product < ApplicationRecord
  CATEGORIES = %w(FRUIT VEGGIE BERRY MEAT FISH GAME HERB).freeze

  before_create :set_defaults

  belongs_to :basket, counter_cache: :items_count

  def serialized(*)
    { name: name, category: category, icon_path: icon_path }
  end

  private

  def set_defaults
    self.name ||= Faker::Food.name
    self.icon_path ||= Faker::Food.icon
    self.category ||= CATEGORIES.sample
  end
end
