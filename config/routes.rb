Patentlookup::Application.routes.draw do

  resources :patents

  match "/" => "pages#home"

end
