#!/usr/bin/env ruby
require 'socket'
require 'logger'
require_relative '/../..utility'

module Memcache
  class Cache

    def self.run
      start_server
    end

    def self.start_server
      options = Utility.parse_args
      port = options["-p"] || 3000

      server = TCPServer.new("localhost", port)
      logger = Logger.new(STDOUT)

      logger.info("Server started on port #{port}")

      loop do
        client = server.accept
        logger.info("Client connected!")

        begin
          request = client.gets
          logger.info("Request received: #{request}!")

          response = "Hello, #{request}!"

          client.puts response

          logger.info("Response sent!")
        rescue => e
          logger.error("Error: #{e.message}")
        ensure
          client.close
          logger.info("Client disconnected!")
        end

      end
    end
  end
end

