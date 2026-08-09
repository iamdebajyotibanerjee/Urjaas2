# config/routes.rb
Rails.application.routes.draw do
  # Public Blog Routes (Read-only)
  resources :blog_posts, only: [ :index, :show ]

  # Public Landing Page Routes
  get "landing_pages", to: "landing_pages#index"
  get "landing_pages/:slug", to: "landing_pages#show", as: :public_landing_page

  # Admin Namespace
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

    resources :blog_posts do
      member do
        patch :toggle_publish
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "landing_pages#home"
end
