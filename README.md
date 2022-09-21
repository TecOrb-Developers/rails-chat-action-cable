## Action cable live chat module APIs rails application 
In this project we have implemented apis to manage authentication and live chatting module using Action cable.
Below are the APIs list (Module-wise)
#### 1. Auth module
- User Registration
- User Login
- Manage Access Token via Refresh Token
- Logout

#### 2. Chat module
- Conversations list
- Remove Conversations (Single and bulk)
- Send message (To specific conversation)
- Remove messages in bulk (From loggedin user's list only, receipients will see the messages)
- Delete Messages (From me ony and from all receipients as well)
- Messages List (From a specific Conversation)
- Mark Messages as seen/unseen (Bulk and single)
- Message delivery/seen/unseen tracking (Bulk and single)

## Info for client app developers (iOS, Android, Web) to integrate these APIs
### You would need to use Action cable SDK for your domain. 
#### Action Cable Response Codes are used to handle on client apps (might be iOS/Android/Web)
We are managing Action Cable notifications by their codes. Here are the codes to handle the received notifications on client applications.
- 10: New Message
- 11: Remove Message
- 12: Seen Message
- 14: Delivered Message

When any activity happen with respect to a message or a new message over the server, client will be notify by these code in Action Cable broadcast on their subscribed channel.

## Postman collection is attached here
We have documented all of these APIs using postman collections with their responses as well. Please download and import this in your postman to get direct endpoints access to the APIs with required body, headers etc.

Here is the postman collection link
https://github.com/TecOrb-Developers/rails-chat-action-cable/blob/main/documentation/Chat-Module.postman_collection.json

## Technical assets and dependencies
###  User authentication is managed via doorkeeper JWT (JSON Web Token)
Doorkeeper JWT adds JWT token support to the Doorkeeper OAuth library.
Complete document for integration is here 
https://github.com/TecOrb-Developers/rails-doorkeeper-auth

### Required dependencies: 
  * Node (v 16)
  * Yarn (v 1.22.19)
  * Ruby (v 3.0.1)  
  * Rails (v 6.1.4)  
  * MySQL (v 8.0.29)
  * Git (v 2.32.1)
  * Redis (v >= 4.2.0)
  * Sidekiq (v 6.4.2)
  * Action cable (v 6.1.4.1)
  * Docker (Optional in case running without containers)

### Major steps are followed to create this project.
  * Prepared with above dependencies
  * Created a new Rails app
  * Database configuration setup (using MySQL)
  * Initialize a local repository using git
  * .gitignore file created to add configuration.yml
  * configuration.yml file created to initialize environment variables  
  * Create a new remote repository using GitHub  
  * Change README.md and documentation added
  * Code Commited and Pushed to GitHub repository

#### Create configuration.yml to setup required environment variables
	* Go to the config directory
	* Create a new file with name configuration.yml

Here are the variables we need to define in this file:
```
DB_DEVELOPMENT: development_db_name

DB_DEVELOPMENT_USERNAME: development_db_username

DB_DEVELOPMENT_PASSWORD: development_db_password

DB_PRODUCTION: production_db_name_xxx

DB_PRODUCTION_USERNAME: production_db_username_xxx

DB_PRODUCTION_PASSWORD: production_db_password_xxx

DB_TEST: test_db_name

JWT_SECRET: jwt_secret_strong_xxxxxxxxxxxxxxxxxxxxxxx

MYSQL_SOCKET: /tmp/mysql.sock

ACTIONCABLE_BASE: https://your-frontend-application-endpoint
```
## Server-side configuration
We are using Doorkeeper gem with JWT authentication to manage signup and login module.
```
# For making this application serve as an OAuth-Provider
# which can be used by OAuth Clients like a custom Webapp
gem 'doorkeeper'

## We are using JWT as the token generator for Doorkeeper hence this gem
gem 'doorkeeper-jwt'
```
We need to configure Doorkeeper as we already did in another sample
https://github.com/TecOrb-Developers/rails-doorkeeper-auth
We have improved above module for the registration process and session management in this repo. You can go thorugh with the commits to get more details.

#### Must go through major gems used in this project
- gem 'mysql2', '~> 0.5' # For databse
- gem 'doorkeeper-jwt' # For authentication
- gem 'bcrypt', '~> 3.1.7' # For authentication
- gem 'will_paginate', '~> 3.1.0' # For paginate active records
- gem 'redis', '~> 4.0' # For caching database
- gem 'sidekiq', '~> 6.4.0' # For background processing (job scheduler)
- gem 'active_model_serializers' # For preparing object-oriented JSON responses.

## Action Cable Channel
User need to subscribe a chat channel to get notify through action cable. Action Cable url will be send by server where the application is hosted followed by the /cable path. Channel name is initiated by a prefix 'notify_' and user's id. 
To subscribe a channel user need to send their access token in 'session_token' key at the time of subscription request. Once user will be authenticated successfully, server will allow to subscribe the requested channel for the client.

## Module wise documentation is attached in below links:
- https://github.com/TecOrb-Developers/rails-chat-action-cable/tree/main/documentation
- https://github.com/TecOrb-Developers/rails-chat-action-cable/blob/main/documentation/1.setup.md
- https://github.com/TecOrb-Developers/rails-chat-action-cable/blob/main/documentation/2.environment_variable.md
- https://github.com/TecOrb-Developers/rails-chat-action-cable/blob/main/documentation/3.action_cable_codes.md
- https://github.com/TecOrb-Developers/rails-chat-action-cable/blob/main/documentation/4.APIs_doc.md
- https://github.com/TecOrb-Developers/rails-chat-action-cable/blob/main/documentation/Chat-Module.postman_collection.json

