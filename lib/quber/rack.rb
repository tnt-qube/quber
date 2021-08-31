require 'json'
require 'rack'

module Quber
  class Rack
    class PayloadError < StandardError; end

    def call(env)
      request = ::Rack::Request.new(env)
      payload = extract_payload(request)

      ActiveJob::Base.execute payload

      [200, {}, ['OK']]
    rescue PayloadError => e
      [400, {}, [e.cause.message]]
    rescue => e
      [500, {}, [e.message]]
    end

    private

      def extract_payload(request)
        JSON.parse(request.body.read).fetch('data')
        rescue JSON::ParserError, KeyError
          raise PayloadError
      end
  end
end