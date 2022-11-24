# Whitebox DDD Example

This project implements some of DDD principles with Ruby On Rails 7
It's not organized with a classic DDD approach, having layers
 * Infrastructure
 * Application
 * Domain
 * Presenter
 
 Instead project is split to bounded contexts (engines folder). Each context has own 
* app
* config (when required)
* spec

folders. 
  
2 Bounded Contexts were extracted:
 * User Access
 * Project Management

Base folder acts more like infrastructure layer. I tried to loose coupling between contexts,
and also showed that each context could be written in it's own manner, for example ProjectManagement
context implements Command/Query pattern, when UserAccess does not.

Requirements:

`Docker` and `docker-compose v3` 

Spin up local environment:

```Bash
docker-compose build
docker-compose up -d
```

Visit `localhost:3000`

Run specs

```Bash
docker-compose exec web rspec engines
```
