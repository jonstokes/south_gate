Rails.application.routes.draw do
  resources :guest_transactions, only: [:new, :create]

  get "guest" => "guest_transactions#new"

end
