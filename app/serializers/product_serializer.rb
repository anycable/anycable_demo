class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :icon_path, :basket_id
end
