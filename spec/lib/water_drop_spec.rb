# frozen_string_literal: true

RSpec.describe WaterDrop do
  describe '#logger' do
    let(:logger) { double }
    let(:log) { double }
    let(:set_logger) { double }

    it 'returns default null logger instnace' do
      allow(described_class.instance_variable_get(:@logger)) { nil }
      expect(described_class.logger).to be_a(NullLogger)
    end

    it 'returns set logger' do
      allow(described_class.instance_variable_get(:@logger)) { set_logger }
      expect(described_class).to receive(:logger).and_return(set_logger)
      described_class.logger
    end
  end

  describe '#setup' do
    context 'when config is valid' do
      let(:setup_process) do
        described_class.setup do |config|
          config.deliver = true
        end
      end

      it 'sets up the configuration' do
        expect(described_class.config.deliver).to eq(true)
      end
    end

    context 'when the config is invalid' do
      let(:setup_process) do
        described_class.setup do |config|
          config.client_id = nil
        end
      end

      after do
        described_class.setup do |config|
          config.client_id = 'waterdrop'
        end
      end

      it { expect { setup_process }.to raise_error(WaterDrop::Errors::InvalidConfiguration) }
    end
  end
end
