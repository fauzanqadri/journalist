require 'sidekiq/web'
require 'sidetiq/web'

class ProxySubdomain
  def self.matches? req
    req.subdomain.present? && req.subdomain != "www"
  end
end
class NoSubdomain
  def self.matches? req
    !req.subdomain.present? || (req.subdomain.present? && req.subdomain == "www")
  end
end
Rails.application.routes.draw do

  devise_for :users, skip: [:registrations]
  devise_scope :user do
    unauthenticated do
      get "/" =>  "devise/sessions#new"
    end
    authenticated :user do
      get '/users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
      put '/users/:id' => 'devise/registrations#update', as: 'registration'
    end
  end

  authenticated :user do
    constraints(ProxySubdomain) do
      mount Journalist::Proxy::Server, at: '/'
    end
  end

  constraints(NoSubdomain) do
    authenticated :user, lambda{|u| u.role == "ADMIN"} do
      mount Sidekiq::Web => "/sidekiq"
      namespace :admin do
        resources :journals, except: :show do
          resources :journal_accounts, except: :show do
            with_options action: "set_status" do |map|
              map.post '/enable', action: "set_status"
              map.post '/disable', action: "set_status"
            end
          end
        end
      end
    end
    root to: "static_page#home"
  end
end
