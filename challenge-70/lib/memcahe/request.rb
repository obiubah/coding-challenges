# frozen_string_literal: true

module Memcache
  class Request
    attr_reader :command, :key, :flags, :byte_count, :data_block

    def initialize(data)
      lines = data.split("\n")
      line_one = lines[0].split(" ")
      @command = line_one[0]
      @key = line_one[1]
      @flags = line_one[2]
      @byte_count = line_one[3]
      @data_block = lines[1]
    end
  end
end
