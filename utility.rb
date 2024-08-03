# frozen_string_literal: true

module Utility
  def self.parse_args
    options = {}

    if ARGV.length % 2 != 0
      puts "Invalid number of arguments"
      exit
    end

    ARGV.each_slice(2) do |key, value|
      options[key] = value
    end

    return options
  end
end
