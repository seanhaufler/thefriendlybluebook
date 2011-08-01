Bluebook::Application.routes.draw do

  match "/search", :to => "Search#index"

  match "/update", :to => "Bluebook#update", :via => :post

  # Send the user home!
  root :to => "Bluebook#index"
end
