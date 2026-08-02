Rails.application.routes.draw do
  get "landing_pages", to: "landing_pages#index"
  get "landing_pages/:slug", to: "landing_pages#show", as: :landing_page
  resources :blog_posts

  # Admin landing page & blocks routes (Task 2)
  namespace :admin do
    resources :landing_pages do
      member do
        patch :toggle_publish
      end
      resources :page_blocks, only: [ :create, :update, :destroy ] do
        collection do
          patch :reorder
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Public landing page route
  get "landing_pages/:slug", to: "landing_pages#show", as: :public_landing_page

  # Defines the root path route ("/")
  root "landing_pages#index"
end
