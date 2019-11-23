Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :group_events, only: [:index, :create, :update, :show, :destroy] do
  	member do 
  		put :publish
  		put :draft
  	end
  end
end
