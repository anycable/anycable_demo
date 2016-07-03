require 'action_cable'
require 'anycable/pubsub'

module ActionCable
  module Server
    class Base
      def pubsub
        @any_pubsub ||= Anycable::PubSub.new
      end
    end
  end
end
