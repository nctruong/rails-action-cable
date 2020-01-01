require 'rails_helper'

describe Guru::Streaming do
  before { @streaming = Guru::Streaming.new('java-job') }

  describe '#broadcast_waiting' do
    it 'sets redis as waiting' do
      @streaming.broadcast_waiting
      expect(Redis.current.get(@streaming.send(:stream_name))).to eq('wait')
    end
  end

  describe '#broadcast_loading' do
    it 'sets redis as loading' do
      @streaming.broadcast_loading
      expect(Redis.current.get(@streaming.send(:stream_name))).to eq('reload')
    end
  end

  describe '#wait?' do
    it 'gets redis as waiting' do
      Redis.current.set(@streaming.send(:stream_name), 'wait')
      expect(@streaming.wait?).to be_truthy
    end

    context 'with broadcasting action' do
      it 'returns true for waiting status' do
        @streaming.broadcast_waiting
        expect(@streaming.wait?).to be_truthy
      end

      it 'returns false for loading status' do
        @streaming.broadcast_loading
        expect(@streaming.wait?).to be_falsey
      end
    end
  end
end
