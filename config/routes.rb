Coach::Application.routes.draw do

  devise_for :users

  root :to => "home#index"

  resources :profiles
  resources :jobs
  resources :camps

  %w[about howitworks howitworks_players howitworks_coaches blog].each do |page|
   get page, controller: 'info', action: page
     end

end
