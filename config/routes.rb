Rails.application.routes.draw do

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
    controllers tokens: 'tokens'
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: "json"} do
    namespace :v1 do
      resources :registrations, only: [:create]
      scope :chats do
        post "index" => "chats#index"
        post "remove" => "chats#delete"
        post "removed" => "chats#removed"
        scope :messages do
          post "create" => "chat_messages#create"
          post "index" => "chat_messages#index"
          post "remove" => "chat_messages#delete"
          post "unsend" => "chat_messages#unsend"
          post "seen" => "chat_messages#seen"
          post "deliver" => "chat_messages#deliver"
        end
      end
    end
  end
end
