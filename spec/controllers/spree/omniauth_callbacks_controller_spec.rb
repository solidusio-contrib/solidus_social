# frozen_string_literal: true

RSpec.describe Spree::OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  let(:omni_params) { double('omni', :[] => nil).as_null_object }
  let(:order) { double('Spree::Order', associate_user: nil) }

  before do
    Rails.application.routes.default_url_options[:host] = 'test.host'
    request.env['omniauth.auth'] = omni_params
    allow(controller).to receive(:sign_in_and_redirect)
    allow(controller).to receive(:redirect_back_or_default)
    allow(Spree::User).to receive(:anonymous!).with(user)
  end

  shared_examples_for 'denied_permissions' do
    before { request.env['omniauth.error'] = 'FAIL' }

    it 'redirects properly' do
      expect(controller).to receive(:redirect_back_or_default)
      controller.github
    end

    it 'displays an error message' do
      controller.github
      expect(flash[:error]).not_to be_blank
    end

    it 'does not attempt authentication' do
      expect(controller).not_to receive(:sign_in_and_redirect)
      controller.github
    end
  end

  shared_examples_for 'associate_order' do
    before { allow(controller).to receive(:current_order).and_return(order) }

    it 'associates the order with the user' do
      expect(order).to receive(:associate_user!).with(user)
      controller.github
    end
  end

  shared_examples_for 'authenticate_as_user' do
    it 'authenticates as that user' do
      expect(controller).to receive(:sign_in_and_redirect).with(user, event: :authentication)
    end
  end

  describe '#callback' do
    context 'when user is authenticated' do
      before do
        allow(controller).to receive(:spree_current_user).and_return(user)
      end

      it_behaves_like 'denied_permissions'

      context 'when existing user_authentication' do
        let(:user_authentication) { double('user_authentication', user: user) }

        before do
          allow(Spree::UserAuthentication).to receive(:find_by).and_return(user_authentication)
        end

        it 'does not need to create the user_authentication' do
          expect(user.user_authentications).not_to receive(:create!)
          controller.github
        end

        it 'sets the flash notice' do
          controller.github
          expect(flash[:notice]).not_to be_blank
        end

        it 'authenticates as that user' do
          expect(controller).to receive(:sign_in_and_redirect)
          controller.github
        end
      end

      context 'when no existing user_authentication' do
        before do
          allow(Spree::UserAuthentication).to receive(:find_by).and_return(nil)
        end

        it 'creates a new user_authentication' do
          expect(user).to receive(:apply_omniauth)
          expect(user).to receive(:save!)
          controller.github
        end

        it 'sets the flash notice' do
          controller.github
          expect(flash[:notice]).not_to be_blank
        end

        it 'redirects properly' do
          expect(controller).to receive(:redirect_back_or_default)
          controller.github
        end

        it_behaves_like 'associate_order'
      end
    end

    context 'when user is not authenticated' do
      before do
        allow(controller).to receive(:spree_current_user).and_return(nil)
      end

      it_behaves_like 'denied_permissions'

      context 'when existing user_authentication' do
        let(:user_authentication) { double('user_authentication', user: user) }

        before do
          allow(Spree::UserAuthentication).to receive(:find_by).and_return(user_authentication)
        end

        it 'does not need to create the user_authentication' do
          expect(user.user_authentications).not_to receive(:create!)
          controller.github
        end

        it 'does not create a new user account' do
          expect(Spree::User).not_to receive :new
          controller.github
        end

        it 'authenticates as that user' do
          expect(controller).to receive(:sign_in_and_redirect).with(:spree_user, user)
          controller.github
        end
      end

      context 'when no existing user_authentication' do
        let(:user) { Spree::User.new }

        before do
          allow(Spree::UserAuthentication).to receive(:find_by).and_return(nil)
          allow(controller).to receive(:auth_hash).and_return('provider' => 'github', 'info' => { 'email' => 'spree@gmail.com' }, 'uid' => '123')
        end

        context "email doesn't belongs to anyone" do
          it 'creates a new user' do
            expect(controller).to receive(:sign_in_and_redirect)
            expect { controller.github }.to change(Spree::User, :count).by(1)
          end

          context 'when `Spree.user_class` has changed' do
            before do
              @previous_user_class = Spree.user_class.to_s
              Spree.user_class = Spree::LegacyUser.to_s

              # the application was initialized with Spree::User, so some
              # some methods do not exist on LegacyUser. In practice, this will
              # not happen as Spree.user_class will not change on the fly like
              # this.
              # this statement simply stubs the required missing method
              allow_any_instance_of(Spree::LegacyUser)
                .to receive(:apply_omniauth)
            end

            after do
              # in order to not affect other tests, restore the original class
              Spree.user_class = @previous_user_class
            end

            it 'creates a new user' do
              expect(Spree::User).not_to receive :new
              expect_any_instance_of(Spree::User).not_to receive :save

              expect { controller.github }
                .to change(Spree::LegacyUser, :count).by(1)
            end
          end
        end

        context 'email belongs to existing user' do
          before { @user = create(:user, email: 'spree@gmail.com') }

          it 'does not create new user' do
            expect { controller.github }.not_to change(Spree::User, :count)
          end

          it 'assigns authentication to existing user' do
            expect { controller.github }.to change(@user.user_authentications, :count).by(1)
          end
        end
      end
    end
  end
end
