import express from 'express'
import edgedb from 'edgedb'
import inertia from 'inertia-node'
import bodyParser from 'body-parser'
import session from 'express-session'

import index from './index.html'

import UserController from './controllers/UserController'
import LoginController from './controllers/LoginController'

const server = express!
server.use bodyParser.json!

# Session middleware setup
const sessionOptions = 
	secret: "not so secret"
	cookie : {}

if server.get('env') === 'production'
	server.set 'trust proxy', 1
	sessionOptions.cookie.secure = true # serve secure cookies

server.use session(sessionOptions)


# Add Inertia middleware
const ASSET_VERSION = "1"
def _html pageString\string, viewData
	let page = index.body.replace ",,,", pageString
	return String page

server.use inertia(_html, ASSET_VERSION)

server.use "/login", LoginController!

# auth middleware
server.use do(req, res, next)
	const {user} = req.session
	if user
		req.Inertia.shareProps
			auth:
				user: user
		return next!
	req.Inertia.redirect "/login" unless user

server.use "/", do(req, res)
	req.Inertia.render 
		component: "dashboard-page"

imba.serve server.listen process.env.PORT or 3000
