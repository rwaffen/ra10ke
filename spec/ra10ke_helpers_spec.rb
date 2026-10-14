# frozen_string_literal: true

require 'spec_helper'
require 'ra10ke/helpers'

RSpec.describe Ra10ke do
  it 'wraps red text in ANSI color and reset codes' do
    expect(described_class.red('Failure')).to eq("\e[31mFailure\e[0m")
  end

  it 'wraps green text in ANSI color and reset codes' do
    expect(described_class.green('Success')).to eq("\e[32mSuccess\e[0m")
  end

  it 'supports an explicit ANSI color code' do
    expect(described_class.colorize('Message', 34)).to eq("\e[34mMessage\e[0m")
  end

  describe 'status emojis' do
    it 'defaults to the success and failure emojis when ENV is unset' do
      allow(ENV).to receive(:fetch).with('GOOD_EMOJI', '👍').and_return('👍')
      allow(ENV).to receive(:fetch).with('BAD_EMOJI', '😨').and_return('😨')

      expect(described_class.good_emoji).to eq('👍')
      expect(described_class.bad_emoji).to eq('😨')
    end

    it 'uses the emojis configured through ENV' do
      allow(ENV).to receive(:fetch).with('GOOD_EMOJI', '👍').and_return('✅')
      allow(ENV).to receive(:fetch).with('BAD_EMOJI', '😨').and_return('❌')

      expect(described_class.good_emoji).to eq('✅')
      expect(described_class.bad_emoji).to eq('❌')
    end

    it 'allows ENV to disable emojis with empty strings' do
      allow(ENV).to receive(:fetch).with('GOOD_EMOJI', '👍').and_return('')
      allow(ENV).to receive(:fetch).with('BAD_EMOJI', '😨').and_return('')

      expect(described_class.good_emoji).to eq('')
      expect(described_class.bad_emoji).to eq('')
    end
  end
end
