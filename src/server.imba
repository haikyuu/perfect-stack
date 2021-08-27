import ContactsController from './controllers/ContactsController'
import express from 'express'

import inertia from './inertia-express/inertia'
import flash from './inertia-express/flash'
import bodyParser from 'body-parser'
import session from 'express-session'
import index from './index.html'

import UserController from './controllers/UserController'
import LoginController from './controllers/LoginController'
import OrganizationsController from './controllers/OrganizationsController'
import {initDatabase} from './services/db'

def createServer
	const closeDatabasePool = await initDatabase!

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
	server.use flash!

	# Add Inertia middleware
	const ASSET_VERSION = "1"
	def _html pageObject, viewData
		String index.body.replace ",,,", JSON.stringify pageObject


	server.use inertia
		version: ASSET_VERSION
		html: _html
		# @ts-ignore
		flashMessages: do(req) req.flash.flashAll!


	server.use "/login", LoginController!

	# auth middleware
	server.use do(req, res, next)
		const {user} = req.session
		if user
			req.Inertia.shareProps
				auth:
					user: user
				requestId:
					Math.random()
			return next!
		req.Inertia.redirect "/login"

	# routes that require logic go here
	server.use "/organizations", OrganizationsController!
	server.use "/contacts", ContactsController!

	# dashboard page
	server.use "/", do(req, res)
		req.Inertia.render 
			component: "dashboard-page"


	imba.serve server.listen process.env.PORT or 3000

createServer!
