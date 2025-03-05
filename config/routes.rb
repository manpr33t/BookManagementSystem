Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, param: :user_id do
    get 'account_status', on: :member
    get 'monthly_report', on: :member
    get 'annual_report', on: :member
  end

  resources :books, only: [:index] do
    get 'income', on: :member
    get 'remaining_copies', on: :member
  end

  resources :transactions, only: [:create] do
    collection do
      post 'borrow'
      post 'return'
    end
  end

  # Catch-all route for undefined routes
  match '*unmatched', to: 'errors#route_not_found', via: :all
end
