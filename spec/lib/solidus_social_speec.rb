# frozen_string_literal: true

RSpec.describe SolidusSocial do
  describe ".configured_providers" do
    subject { described_class.configured_providers }

    it { is_expected.to match_array(["amazon", "facebook", "github", "google_oauth2", "twitter"]) }
  end

  describe ".init_providers" do
    subject { described_class.init_providers }

    around do |example|
      previous_providers = Spree::SocialConfig.providers
      Spree::SocialConfig.providers = {facebook: {api_key: "secret_key", api_secret: "secret_secret"}}
      example.run
      Spree::SocialConfig.providers = previous_providers
    end

    it "sets up Devise for the given providers" do
      expect(described_class).to receive(:setup_key_for).with(:facebook, "secret_key", "secret_secret")
      subject
    end
  end
end
