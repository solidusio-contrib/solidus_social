# frozen_string_literal: true

RSpec.describe SolidusSocial do
  context 'constants' do
    it { is_expected.to be_const_defined(:OAUTH_PROVIDERS) }

    it 'contain all providers' do
      oauth_providers = [
        SolidusSocial::Provider.new("Facebook", "facebook", true),
        SolidusSocial::Provider.new("Twitter", "twitter2", false),
        SolidusSocial::Provider.new("GitHub", "github", true),
        SolidusSocial::Provider.new("Google", "google_oauth2", true)
      ]
      expect(described_class::OAUTH_PROVIDERS).to match_array oauth_providers
    end
  end
end
