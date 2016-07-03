require 'grpc'
require 'anycable'
require 'anycable/rpc_handler'

# Set GRPC logger
module GRPC
  def self.logger
    Anycable.logger
  end
end

module Anycable
  # Wrapper over GRPC server
  module Server
    def self.start
      s = GRPC::RpcServer.new
      s.add_http2_port(Anycable.config.rpc_host, :this_port_is_insecure)
      s.handle(Anycable::RPCHandler)
      Anycable.logger.info "RPC server is listening on #{Anycable.config.rpc_host}"
      s.run_till_terminated
    end
  end
end
