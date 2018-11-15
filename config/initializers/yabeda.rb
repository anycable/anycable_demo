# frozen_string_literal: true

require "anycable/middleware"

class MetricsMiddleware < AnyCable::Middleware
  BUCKETS = [
    0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10
  ].freeze

  # handler - is a method (Method object) of RPC handler which is called
  # rpc_call - is an active gRPC call
  # request - is a request payload (incoming message)
  def call(request, rpc_call, handler)
    labels = { method: handler.name }
    start = Time.now
    begin
      yield
      Yabeda.anycable_rpc_success_total.increment(labels)
    rescue Exception # rubocop: disable Lint/RescueException
      Yabeda.anycable_rpc_failed_total.increment(labels)
      raise
    ensure
      time = elapsed(start)
      Yabeda.anycable_rpc_runtime.measure(labels, time)
      Yabeda.anycable_rpc_executed_total.increment(labels)
    end
  end

  private

  def elapsed(start)
    (Time.now - start).round(3)
  end
end

Yabeda.configure do
  group :anycable

  counter   :rpc_executed_total, comment: "Total number of rpc calls"
  counter   :rpc_success_total,  comment: "Total number of successfull rpc calls"
  counter   :rpc_failed_total,   comment: "Total number of failed rpc calls"
  histogram :rpc_runtime,        comment: "RPC runtime", unit: :seconds, per: :method,
    buckets: MetricsMiddleware::BUCKETS
end

AnyCable.configure_server do
  AnyCable.middleware.use(MetricsMiddleware)

  Yabeda::Prometheus::Exporter.start_metrics_server!
end
