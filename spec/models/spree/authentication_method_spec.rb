# frozen_string_literal: true

RSpec.describe Spree::AuthenticationMethod do
  describe ".provider_options" do
    subject { described_class.provider_options }

    let(:expected_provider_options) do
      [
        %w[Facebook facebook],
        %w[Github github],
        %w[Google google_oauth2],
        %w[Twitter2 twitter2]
      ]
    end

    it { is_expected.to match_array(expected_provider_options) }
  end
end
