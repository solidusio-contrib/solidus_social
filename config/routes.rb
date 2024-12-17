# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  devise_for :spree_user,
    class_name: Spree.user_class_name,
    only: [:omniauth_callbacks],
    controllers: { omniauth_callbacks: 'spree/omniauth_callbacks' },
    path: Spree::SocialConfig[:path_prefix]
  resources :user_authentications

  get 'account' => 'users#show', as: 'user_root'

  namespace :admin do
    resources :authentication_methods
  end
end
