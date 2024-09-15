# frozen_string_literal: true

require 'rspec'
require_relative '../../../challenge-70/lib/memcache/process_command'
require_relative '../../../challenge-70/lib/memcache/request'

RSpec.describe Memcache::ProcessCommand do

  let(:set_command) { "set" }
  let(:key) { "test" }
  let(:flags) { "0" }
  let(:exptime) { "1" }
  let(:byte_count) { "4" }
  let(:should_reply) { "" }
  let(:data_block) { "test" }
  let(:get_data) { "#{set_command} #{key} #{flags} #{exptime} #{byte_count} #{should_reply}\n#{data_block}\n" }
  let(:get_request) { Memcache::Request.new(get_data) }
  let(:request) { get_request }
  let(:response) { Memcache::ProcessCommand.process_request(request) }

=begin
REQUEST 2
get test
RESPONSE 2
END

REQUEST 3
set test 0 100 4
test
RESPONSE 3
STORED

REQUEST 4
get test
RESPONSE 4
VALUE test 0 4
test
END

REQUEST 5
set test 0 -1 4
test
RESPONSE 5
STORED

REQUEST 6
get test

RESPONSE 6
END

=end

  context 'when condition' do
    it 'succeeds' do
      expect(response).to eq("STORED\n")
    end
  end
end
