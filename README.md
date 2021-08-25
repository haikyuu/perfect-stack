# perfect-stack
The perfect stack is comprised of three main technologies:
- DB: EdgeDB
- Imba : as the programming language with an integrated UI library
- http library: I used express, but I intend to move to Fastify later. You can use the one you prefer here.

What makes this stack perfect is Inertia. 

Included in this repo is an inertia adapter for Imba as well as an inertia adapter for express I forked from https://github.com/jordankaerim/inertia-node to add support for flash messages
## Installation
- Install [edgedb](https://www.edgedb.com/docs/quickstart)
- Run `edgedb project init`
- Run `npm install`
- Run `npm start-server` 

If you add some tailwindcss classes, make sure you run `npm run tailwind` to build the css file or run `npm start` to watch on the changes

# Roadmap
- [ ] Complete Ping CRM functionality
  - [ ] Manage Contacts
  - [ ] Manage users (contains upload)
- [ ] Polish the API of inertia adapters for Imba
- [ ] Extract useful Imba components (e.g: portal)
- [ ] Polish the API of inertia express adapter
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Deploy to the cloud

# License
MIT license.