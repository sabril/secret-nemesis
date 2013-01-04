Patentlookup::Application.routes.draw do

  resources :patents
  match "/advanced_search" => "patents#advanced_search"
  match "/about" => "pages#about"
  match "/" => "pages#home"

end
