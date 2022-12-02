## Doorkeeper Auth section endpoints 

#### Login (Issue access token)
- You need to call POST /oauth/token with body mentioned below. We need to add grant_type and client id and secrets in the body with email and password. 

- The way of passing client_id and client_secret as mentioned below body isn't recommended by the RFC however this will work. We have to pass these through encrypted headers. I will explain the secure way at bottom section.

Request body:
````
{
    "grant_type": "password",
    "email": "jai@example.com",
    "password": "0000000",
    "client_id": "uZmSxDz1zznGyldoeo3zzxxxxxxxxxxxxxxxxxx",
    "client_secret": "absxyMmgaQWD1xxxxxxxxxxxxxxxxxx"
}
````

#### Use Refresh Token to issue a new access token
- You need to call POST /oauth/token with body mentioned below. The only change is grant_type value.

Request body:
``````
{
    "grant_type": "refresh_token",
    "refresh_token": "KL75Xrdxxxxxxxxxxxxxxxxxxxxx",
    "client_id": "uZmSxDz1zznGyldoeo3zzxxxxxxxxxxxxxxxxxx",
    "client_secret": "absxyMmgaQWD1xxxxxxxxxxxxxxxxxx"
}

``````

#### Logout (Revoke an access token)
- You need to call POST /token/revoke 

- Key "token" value of access_token you wanna to revoke in body

- Include authorization headers (**HTTP-Authrozation: Basic Base64(client_id:client_secret)**) to inform the server that this request is authorized to perform an action. 

- Check below section to secure this data transmission


#### Send client_id and client_secret in a secure way instead of body
- Alternatively you could send client_id and client_secret via body params, but this method isn't recommended by the RFC. So here is another way you can pass your client data.

- Don't forget that if the token you wanna to revoke was issued to some specific client - only this client could revoke the token (it's credentials must be used to authorize the request).

Here is an Example:

Suppose your client_id is xxxxxxxx1234 and client_secret is zzzzzzzz0987 so you can generate base64 basic token via:

````
data = "xxxxxxxx1234:zzzzzzzz0987"
basic_auth = Base64.strict_encode64(data) 
# returns: dVptU3hEejF6em5HeVZHR18ybWg2amNub1pZSWNHcW5xQy1DSm02SEtpVTphYnN4eU1tZ2FRV0QxV0dUTjExd29jYlBRWGJqTkFWYlRfSl9fYjE5TnZr
````
##### Request:

`POST	/token/revoke`

Use (above generated) token in request headers:

````
{
	"Authorization":	"Basic dVptU3hEejF6em5HeVZHR18ybWg2amNub1pZSWNHcW5xQy1DSm02SEtpVTphYnN4eU1tZ2FRV0QxV0dUTjExd29jYlBRWGJqTkFWYlRfSl9fYjE5TnZr"
}
````
Body: 

````
{
    "token": "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJNeSBBcHAiLCJpYXQiOjE2NjQ5NjY3MTcsImp0aSI6IjQyMjhkNzE4LWMzYTQtNGI2My1hYjEwLTRhYWQxM2Q2NzFkZiIsInVzZXIiOnsiaWQiOjEsImVtYWlsIjoiamFpQHRlY29yYi5jbyJ9fQ.NqqCEoYC4E3D5xo3_VHQm_eW292jVQGFWM53MCozyk9XI8rErYE6dNxw0Ksai853X6hSLw9ujuapD2rX4XXaOQ"
}
````