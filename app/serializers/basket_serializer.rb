class BasketSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo_path, :description, :owner, :items_count
end
