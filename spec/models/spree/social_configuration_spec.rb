# frozen_string_literal: true

RSpec.describe Spree::SocialConfiguration do
  it { is_expected.to respond_to(:path_prefix) }
end
