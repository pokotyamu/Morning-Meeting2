Rails.application.routes.draw do
  root 'teams#index'

  resources :teams, only: [:new, :create] do
    member do
      get 'slides/edit'
      post 'slides', controller: 'slides', action: :create
    end
  end
  resources :announcements, only: [:new, :create, :update]
end
