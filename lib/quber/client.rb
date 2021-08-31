module Quber
  class Client
    def initialize options = {}
      @http = HTTP.new options
    end

    def put options = {}
      @http.post('jobs', options)
    end
  end
end