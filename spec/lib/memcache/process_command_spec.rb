# frozen_string_literal: true

require 'rspec'
require_relative '../../../challenge-70/lib/memcache/process_command'
require_relative '../../../challenge-70/lib/memcache/request'

RSpec.describe Memcache::ProcessCommand do

  let(:set_command) { "set" }
  let(:get_command) { "get" }
  let(:key) { "test" }
  let(:flags) { "0" }
  let(:exptime) { "-1" }
  let(:byte_count) { "4" }
  let(:should_reply) { "" }
  let(:data_block) { "test" }
  let(:set_request) { Memcache::Request.new("#{set_command} #{key} #{flags} #{exptime} #{byte_count} #{should_reply}\n#{data_block}\n") }
  let(:get_request) { Memcache::Request.new("#{get_command} #{key}\n") }
  let(:request) {}
  let(:response) { Memcache::ProcessCommand.process_request(request) }

  context 'when the command is SET' do
    let(:request) { set_request }
    it 'succeeds' do
      expect(response).to eq("STORED\n")
    end
  end
  context 'when the command is GET' do
    let(:request) { get_request }
    it 'returns empty when no data' do
      expect(response).to eq("END\n")
    end
    context 'when there is data on the server' do
      let(:exptime) { 100 }
      before do
        Memcache::ProcessCommand.process_request(set_request)
      end
      it 'returns the data' do
        expect(response).to eq("VALUE test 0 4\ntest\nEND\n")
      end
      context 'when the data has expired' do
        # TODO: This test is not working as expected. The data is not expiring.
        let(:exptime) { 5 }
        let(:key) { "expired" }
        it 'returns empty' do
          allow(Time).to receive(:now).and_return(Time.now + exptime.to_i + 1)
          puts Time.now
          puts exptime.to_i
          expect(response).to eq("END\n")
        end
      end
    end
  end
end
