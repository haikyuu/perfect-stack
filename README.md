# perfect-stack
The perfect stack is comprised of three main technologies:
- DB: EdgeDB
- Imba : as the programming language with an integrated UI library
- Inertia: a glue between the UI and the server.
- http library: I used express, but I intend to move to Fastify later. You can use the one you prefer here.

These technologies together make the stack perfect in my opinion. They are:
  - ✨ Expressive
  - 🛠 Productive
  - 🤯 Powerful
  - 🏎 Fast

# Original Ping CRM
https://demo.inertiajs.com


Included in this repo is an inertia adapter for Imba as well as an inertia adapter for express I forked from https://github.com/jordankaerim/inertia-node to add support for flash messages.

## Installation
- Install [edgedb](https://www.edgedb.com/docs/quickstart)
- Run `edgedb project init`
- Run `npm install`
- Run `npm start-server` 

If you add some tailwindcss classes, make sure you run `npm run tailwind` to build the css file or run `npm start` to watch on the changes

# Done
- ✅ All CRM features
  - Login
  - Manage Organizations
    -  Create
    -  Update
    -  Delete (soft deletes)
    -  Restore
    - Search and filter
  - Manage Users (with file upload)
  - Manage Contacts

# Roadmap
- [ ] Polish the API of inertia adapter for Imba and publish to npm
- [ ] Polish the API of inertia express adapter and publish to npm
- [ ] Add some tests
- [ ] Deploy to the cloud

# License
MIT license.
