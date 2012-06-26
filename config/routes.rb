Patentlookup::Application.routes.draw do

  resources :patents

  get "pages/home"
  
  match "/" => "patents#index"

end
