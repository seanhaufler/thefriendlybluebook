Bluebook::Application.routes.draw do

  match "/search",    :to => "Search#index"

  match "/add",       :to => "Users#add",         :via => :post
  match "/calendar",  :to => "Users#calendar",    :via => :get
  match "/ical",      :to => "Users#ical",        :via => :post
  match "/remove",    :to => "Users#remove",      :via => :post
  match "/update",    :to => "Users#update",      :via => :post
  
  match "/comment",   :to => "Courses#comment",   :via => :post

  # Send the user home!
  root :to => "Bluebook#index"
end
