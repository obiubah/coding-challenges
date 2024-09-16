# frozen_string_literal: true

module Memcache
  class ProcessCommand
    @cache = {}

    def self.process_request(request)
      remove_key_if_expired(request)
      command = request.command.to_sym
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

    def self.remove_key_if_expired(request)
      return unless @cache.key?(request.key)
      time_to_expire = @cache[request.key].exptime + request.request_time
      if time_to_expire == request.request_time
        nil
      end
      if time_to_expire < Time.now.to_i
        @cache.delete(request.key)
      end
    end

    private_class_method :remove_key_if_expired
  end
end
