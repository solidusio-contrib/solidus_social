# frozen_string_literal: true

RSpec.describe SolidusSocial do
  context 'constants' do
    it { is_expected.to be_const_defined(:OAUTH_PROVIDERS) }

    it 'contain all providers' do
      oauth_providers = [
        %w(Facebook facebook true),
        %w(Github github false),
        %w(Google google_oauth2 true),
        %w(Twitter twitter2 false)
      ]
      expect(described_class::OAUTH_PROVIDERS).to match_array oauth_providers
    end
  end
end
