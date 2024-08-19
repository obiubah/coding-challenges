# frozen_string_literal: true

module Memcache
  class ProcessCommand

    @cache = {}

    def self.process_request(request)
      command = request.command

      #     "set" means "store this data".
      #
      #       "add" means "store this data, but only if the server *doesn't* already
      # hold data for this key".
      #
      #       "replace" means "store this data, but only if the server *does*
      # already hold data for this key".
      #
      #       "append" means "add this data to an existing key after existing data".
      #
      #       "prepend" means "add this data to an existing key before existing data".

      case command
      when :set
        set(request)
      when :get
        get(request)
      else
        "ERROR\r\n"
      end
    end

    def self.set(request)
      key = request.key
      @cache[key] = request
    end

    def self.get(request)
      key = request.key
      @cache[key]
    end

  end
end
