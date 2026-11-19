Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"
      get "auth/me", to: "auth#me"

      post "books/:id/cover_image", to: "books#cover_image"
      delete "books/:id/cover_image", to: "books#remove_cover_image"

      resources :books
    end
  end
end