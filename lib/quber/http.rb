require 'uri'
require 'json'
require 'net/http'
require 'net/http/persistent'

module Quber
  class HTTP
    Response = Struct.new(:code, :body)

    VERBS = {
      get:    Net::HTTP::Get,
      post:   Net::HTTP::Post,
      put:    Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }

    def initialize options = {}
      @defaults = {
        connection: Net::HTTP::Persistent.new,
        api_uri:    ENV['QUBER_API_URI']   || 'http://localhost:5672/api/v1/',
        api_token:  ENV['QUBER_API_TOKEN'] || '1234567890'
      }.merge!(options)
    end

    def base_headers
      {
        'X-Auth-Token' => @defaults[:api_token],
        'User-Agent'   => "Quber/#{Quber::VERSION}",
        'Content-Type' => 'application/json'
      }
    end

    def get(path, options = {})
      execute(path, :get, options)
    end

    def post(path, options = {})
      execute(path, :post, options)
    end

    def put(path, options = {})
      execute(path, :put, options)
    end

    def delete(path, options = {})
      execute(path, :delete, options)
    end

    private
      def execute(path, method, options = {})
        uri = URI.join(@defaults[:api_uri], path)
        req = VERBS[method].new(uri.request_uri)

        # Build headers and body
        options.transform_keys!(&:to_s) unless options.empty?
        headers = base_headers.merge(options.dig('headers') || options)
        headers.each{ |k,v| req[k] = v }
        req.body = (options.dig('body') || options || {}).to_json

        # Send request and process response
        resp = @defaults[:connection].request(uri.to_s, req)
        body = resp.body.empty? ? {} : JSON.parse(resp.body)
        Response.new(resp.code.to_i, body)
      end
  end
end