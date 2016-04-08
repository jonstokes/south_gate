Rails.application.routes.draw do
  root "guest_transactions#new"

  # Webhook for Unifi Controller
  get "guest" => "guests_controller#guest"

  resources :guest_transactions, only: [:new, :create, :show]
end
