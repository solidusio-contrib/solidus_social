# frozen_string_literal: true

RSpec.describe Spree::AuthenticationMethod do
  describe 'validations' do
    let(:authentication_method) { described_class.new }

    it 'is invalid without a provider' do
      authentication_method.api_key = 'test_key'
      authentication_method.api_secret = 'test_secret'

      expect(authentication_method).not_to be_valid
      expect(authentication_method.errors[:provider]).to include("can't be blank")
    end

    it 'is invalid without an api_key' do
      authentication_method.provider = 'google'
      authentication_method.api_secret = 'test_secret'

      expect(authentication_method).not_to be_valid
      expect(authentication_method.errors[:api_key]).to include("can't be blank")
    end

    it 'is invalid without an api_secret' do
      authentication_method.provider = 'google'
      authentication_method.api_key = 'test_key'

      expect(authentication_method).not_to be_valid
      expect(authentication_method.errors[:api_secret]).to include("can't be blank")
    end

    it 'is valid with all required attributes' do
      authentication_method.provider = 'google'
      authentication_method.api_key = 'test_key'
      authentication_method.api_secret = 'test_secret'

      expect(authentication_method).to be_valid
    end
  end

  describe '.active_authentication_methods?' do
    subject { described_class.active_authentication_methods? }

    let!(:active_method) { Spree::AuthenticationMethod.create!(provider: 'facebook', environment: Rails.env, api_key: 'test', api_secret: 'test', active: true) }
    let!(:inactive_method) { Spree::AuthenticationMethod.create!(provider: 'google_oauth2', environment: Rails.env, api_key: 'test', api_secret: 'test', active: false) }

    context 'when there are active authentication methods' do
      it { is_expected.to be true }
    end

    context 'when there are no active authentication methods' do
      before { active_method.update(active: false) }

      it { is_expected.to be false }
    end
  end

  describe '.available_for' do
    let(:user) { create(:user) }
    let!(:auth_method_1) { Spree::AuthenticationMethod.create!(provider: 'facebook', environment: Rails.env, api_key: 'test', api_secret: 'test', active: true) }
    let!(:auth_method_2) { Spree::AuthenticationMethod.create!(provider: 'google_oauth2', environment: Rails.env, api_key: 'test', api_secret: 'test', active: true) }
    let!(:user_authentication) { Spree::UserAuthentication.create(user: user, uid: 'uniq_id', provider: 'facebook') }

    subject { described_class.available_for(user) }

    context 'when the user has no authentications' do
      let(:user) { create(:user, user_authentications: []) }

      it 'returns all methods for the current environment' do
        expect(subject).to contain_exactly(auth_method_1, auth_method_2)
      end
    end

    context 'when the user has existing authentications' do
      it 'excludes methods for already authenticated providers' do
        expect(subject).to contain_exactly(auth_method_2)
      end
    end

    context 'when the user is nil' do
      let(:user) { nil }

      it 'returns all methods for the current environment' do
        expect(subject).to contain_exactly(auth_method_1, auth_method_2)
      end
    end
  end

  describe '#oauth_scope' do
    it 'returns the default scope for twitter2' do
      auth_method = described_class.new(provider: 'twitter2')
      expect(auth_method.oauth_scope).to eq('tweet.read users.read')
    end

    it 'returns nil for other providers' do
      auth_method = described_class.new(provider: 'facebook')
      expect(auth_method.oauth_scope).to be_nil
    end
  end
end
