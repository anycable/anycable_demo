class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def serialized(options = {})
    ActiveModelSerializers::SerializableResource.new(self, options)
  end
end
