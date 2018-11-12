BloodContracts.config do |config|
  config.storage[:postgres][:connection] = -> do
    ActiveRecord::Base.connection.raw_connection
  end
end
