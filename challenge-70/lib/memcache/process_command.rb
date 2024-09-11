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
      when :add
        add(request)
      when :replace
        replace(request)
      else
        # type code here
      end
    end

    def self.set(request)
      key = request.key
      @cache[key] = request
      return "STORED\n" if request.should_reply
    end

    def self.get(request)
      response = ""
      if @cache.key?(request.key)
        key = request.key
        value = @cache[key]
        response = "VALUE #{key} #{value.flags} #{value.byte_count}\n#{value.data_block}\n"
      end
      return "#{response}END\n"
    end

    def self.add(request)
      if @cache.key?(request.key)
        return "NOT_STORED\n"
      end
      return set(request)
    end

    def self.replace(request)
      unless @cache.key?(request.key)
        return "NOT_STORED\n"
      end
      return set(request)
    end
  end
end
