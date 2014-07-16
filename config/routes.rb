Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :products do
      resources :prices, :only => [:index, :create]
    end
  end
end