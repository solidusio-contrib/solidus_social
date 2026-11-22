# frozen_string_literal: true

RSpec.describe SolidusSocial::Engine do
  describe "USER_DECORATOR_PATH" do
    it "is pointing to the correct file" do
      expect(File.exist?(described_class::USER_DECORATOR_PATH)).to eq(true)
    end
  end
end
