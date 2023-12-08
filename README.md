# README
## How to run the project
```
cd PROJECT_PATH
docker-compose up
```

## Database Tables

Application: `id`, `token`, `name`, `chats_count`,

Chat: `id`, `application_id`, `number`, `title`, `messages_count`

Message: `id`, `chat_id`, `number`, `body`

## Endpoints
You can find in the project root folder a Postman Collection containing all implemeneted Endpoints with its payloads if required.

### Applications
`GET     /applications ` Retrieve all Applications Data.

`POST     /applications` Create an Application.

`GET     /applications/:token` Retrieve an Application's data by its token.

`PUT     /applications/:token` Update an Application's data by its token.

### Chats

`GET     /applications/:application_token/chats` Retrieve all Application's Chats Data.

`POST     /applications/:application_token/chats` Create a Chat by its Application's Token.

`GET     /applications/:application_token/chats/:number` Retrieve a Chat data by its number and Application's Token.  

`PUT    /applications/:application_token/chats/:number` Update a Chat by its number and Application's Token.

`POST   /applications/:application_token/chats/:number/search/:query`  Search a specific Chat by a given query.

### Messages [create, update, read]
`GET     /applications/:application_token/chats/:chat_number/messages` Retrieve all Chat's Messages Data.

`POST     /applications/:application_token/chats/:chat_number/messages` Create a Message by its Application's Token and Chat number.

`GET     /applications/:application_token/chats/:chat_number/messages/:number` Retrieve a Message data by its number and Chat number and Application's Token. 

`PUT     /applications/:application_token/chats/:chat_number/messages/:number` Update a Message by its number and Chat number and Application's Token.
