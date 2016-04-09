# Include in services to wrap call method
module Service
  extend ActiveSupport::Concern

  included do
    attr_reader :error

    def self.call(*args)
      new.call(*args)
    end

    def success?
      error ? false : true
    end
  end

  # Base success class for service
  # Accepts any data. Usually object.
  class Success
    attr_reader :data, :code, :details

    def initialize(data, code = 200, details = 'ok')
      @data = data
      @code = code
      @details = details
    end

    def success?
      true
    end
  end

  # Base Error class to sub class into meaningful errors
  class Error
    attr_reader :error, :code, :details
    attr_accessor :error_object

    def initialize(error = nil, code = nil, details = nil)
      @error = error
      @code = code
      @details = details
    end

    def error_message
      error.to_s
    end

    def success?
      false
    end

    def json_resource_errors
      { error: error, message: error_message, code: code, details: details }
    end
  end

  # Resource not found
  class NotFoundError < Error
    def initialize(details, opts = {})
      super(:not_found, 404, details)
      @error_object = opts[:error_object]
    end

    def error_message
      'Resource not found'
    end
  end
end
