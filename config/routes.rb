Bluebook::Application.routes.draw do

  match "/search", :to => "Search#index"

  match "/update", :to => "Users#update", :via => :post
  match "/add", :to => "Users#add", :via => :post
  match "/remove", :to => "Users#remove", :via => :post

  # Send the user home!
  root :to => "Bluebook#index"
end
