# frozen_string_literal: true

RSpec.describe Spree::SocialConfig do
  it "changing a preference does not create a Spree::Preference" do
    expect { subject.path_prefix = 'customer' }.not_to change(Spree::Preference, :count)
  end
end
