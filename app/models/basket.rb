class Basket < ApplicationRecord
  before_create :set_defaults

  private

  def set_defaults
    self.name ||= Faker::Hipster.word
    self.description ||= Faker::Hipster.paragraph
    self.owner ||= Faker::Internet.user_name
    self.logo_path ||= "https://unsplash.it/400/200?image=#{rand(1000)}"
  end
end
