# frozen_string_literal: true

module Memcache
  class Request
    attr_reader :command, :key, :flags, :exptime, :byte_count, :should_reply, :data_block, :request_time

    def initialize(data)
      lines = data.split("\n")
      line_one = lines[0].split(" ")
      @command = line_one[0]
      @key = line_one[1]
      @request_time = Time.now.to_i
      if @command == "set"
        @flags = line_one[2]
        @exptime = line_one[3].to_i
        @byte_count = line_one[4]
        @should_reply = line_one[5] == "noreply" ? false : true
        raise StandardError, "CLIENT_ERROR Byte size exceeds size of provided data block\n" if @byte_count.to_i > lines[1].length
        @data_block = lines[1].slice(0, @byte_count.to_i)
      end
    end
  end
end
