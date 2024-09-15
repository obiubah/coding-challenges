# frozen_string_literal: true

require 'rspec'
require_relative '../../../challenge-70/lib/memcache/request'

RSpec.describe Memcache::Request do
  let(:set_command) { "set" }
  let(:get_command) { "get" }
  let(:command) { set_command }
  let(:key) { "key" }
  let(:flags) { "0" }
  let(:exptime) { "20" }
  let(:byte_count) { "7" }
  let(:should_reply) { "" }
  let(:data_block) { "testing" }
  let(:set_data) { "#{command} #{key} #{flags} #{exptime} #{byte_count} #{should_reply}\n#{data_block}\n" }
  let(:get_data) { "#{command} #{key}\n" }
  let(:request_data) { set_data }
  let(:request) { described_class.new(request_data) }

  context "when it is a set command" do
    context 'when new instance is created' do
      it 'succeeds with correct parameters' do
        expect(request.command).to eq(command)
        expect(request.key).to eq(key)
        expect(request.flags).to eq(flags)
        expect(request.exptime).to eq(exptime)
        expect(request.byte_count).to eq(byte_count)
        expect(request.should_reply).to eq(true)
        expect(request.data_block).to eq(data_block)
      end
    end
    context "when noreply is sent" do
      let(:should_reply) { "noreply" }
      it 'sets should_reply to false' do
        expect(request.should_reply).to eq false
      end
    end
    context "when byte count and data block don't match" do
      let(:data_block) { "123456789" }
      context "byte count < bytes in data block" do
        it "should only take the first n bytes" do
          expect(request.data_block).to eq("1234567")
        end
      end
      context "byte count > bytes in data block" do
        let(:byte_count) { "12" }
        it "throws an exception" do
          expect { request }.to raise_error(StandardError, "CLIENT_ERROR Byte size exceeds size of provided data block\n")
        end
      end
    end
  end

  context "when it is a get command" do
    let(:command) { get_command }
    let(:request_data) { get_data }
    context 'when new instance is created' do
      it 'succeeds with correct parameters' do
        expect(request.command).to eq(get_command)
        expect(request.key).to eq(key)
      end
    end
  end
end
