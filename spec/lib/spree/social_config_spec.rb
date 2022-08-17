# frozen_string_literal: true

RSpec.describe Spree::SocialConfig do
  it "changing a preference does not create a Spree::Preference" do
    expect { subject.path_prefix = 'customer' }.not_to change(Spree::Preference, :count)
  end

  it "holds configuration for the five default providers" do
    expect(subject.providers.keys).to match_array([:github, :google_oauth2])
  end
end
