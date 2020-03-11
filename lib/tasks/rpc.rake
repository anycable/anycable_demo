# frozen_string_literal: true

namespace :rpc do
  desc "Make test GRPC call"
  task check: :environment do
    require 'grpc'
    GRPC::DefaultLogger::LOGGER = Logger.new(STDOUT)
    stub = Anycable::Connector::Stub.new('localhost:50051', :this_channel_is_insecure)
    stub.connect(Anycable::ConnectionRequest.new(path: 'qwe', headers: { 'cookie' => 'qweqw' }))
  end
end
