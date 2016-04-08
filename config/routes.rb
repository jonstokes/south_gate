Rails.application.routes.draw do
  root "guest_transactions#new"
  
  resources :guest_transactions, only: [:new, :create]

  get "guest" => "guest_transactions#new"

end
