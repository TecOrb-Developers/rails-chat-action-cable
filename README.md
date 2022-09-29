# Action cable live chat module APIs rails application 

##  User authentication is managed via doorkeeper JWT (JSON Web Token)
Doorkeeper JWT adds JWT token support to the Doorkeeper OAuth library.

## Required dependencies: 
  * Ruby is installed (v 3.0.1)  
  * Rails is installed (v 6.1.4)  
  * MySQL is installed
  * Git is installed  
  * GitHub account is created
  * Redis installed

## Major steps are followed to setup:
  * Setup a new Rails app
  * Database configuration setup (using MySQL)
  * Initialize a local repository using git
  * .gitignore file created to add configuration.yml
  * configuration.yml file created to initialize environment variables  
  * Create a new remote repository using GitHub  
  * Change README.md and documentation added
  * Code Commited and Pushed to GitHub repository

# Create configuration.yml to setup required environment variables
	* Go to the config directory
	* Create a new file with name configuration.yml

## Required variables to define in configuration.yml
Here are the variables we need to define in this file:
<code>
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
</code>

# Server-side configuration
We are using Doorkeeper gem with JWT authentication to manage signup and login module.
```
# For making this application serve as an OAuth-Provider
# which can be used by OAuth Clients like a custom Webapp
gem 'doorkeeper'

# We are using JWT as the token generator for Doorkeeper hence this gem
gem 'doorkeeper-jwt'
```
We need to configure Doorkeeper as we already did in another sample
https://github.com/TecOrb-Developers/rails-doorkeeper-auth
We have improved above module for the registration process and session management in this repo. You can go thorugh with the commits to get more details.

In this project we have implemented apis for 
#### Auth module
- User Registration
- User Login
- Manage Access Token via Refresh Token
- Logout

#### Chat module
- Conversations list
- Remove Conversations in bulk
- Send message
- Remove messages in bulk
- Messages List
- Mark Messages as seen/unseen
- Message delivery/seen/unseen tracking

### Action Cable Response Codes
We are managing Action Cable notifications by their codes. Here are the codes to handle the received notifications on client applications.
- 10: New Message
- 11: Remove Message
- 12: Seen Message
- 14: Delivered Message

When any activity happen with respect to a message or a new message over the server, client will be notify by these code in Action Cable broadcast on their subscribed channel.

## Action Cable Channel
User need to subscribe a chat channel to get notify through action cable. Action Cable url will be send by server where the application is hosted followed by the /cable path. Channel name is initiated by a prefix 'notify_' and user's id. 
To subscribe a channel user need to send their access token in 'session_token' key at the time of subscription request. Once user will be authenticated successfully, server will allow to subscribe the requested channel for the client.