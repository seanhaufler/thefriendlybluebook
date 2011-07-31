Bluebook::Application.routes.draw do

  match "/search", :to => "Search#index"

  # Send the user home!
  root :to => "Bluebook#index"
end
