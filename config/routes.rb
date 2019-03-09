Rails.application.routes.draw do
  root 'teams#index'

  resources :teams, only: [:new, :create, :edit, :update, :destroy] do
    member do
      get 'slides/edit'
      patch 'slides', controller: 'slides', action: :update
      get 'slide', controller: 'slides', action: :show
    end
  end
  resources :announcements, only: [:new, :create, :update]
end
