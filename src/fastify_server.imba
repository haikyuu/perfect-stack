import  UsersController from './controllers/UsersController'
import  ContactsController from './controllers/ContactsController'
import  OrganizationsController from './controllers/OrganizationsController'
import LoginController from './controllers/LoginController'
import { fastifyCookie } from 'fastify-cookie'
import Fastify from 'fastify'
import {initDatabase} from './services/db'
import fastifySession from 'fastify-secure-session'
import index from './index.html'
import inertia from './inertia-fastify/inertia'
import flash from 'fastify-flash'
import fastifyRequestLogger from '@mgcrea/fastify-request-logger';
import prettifier from '@mgcrea/pino-pretty-compact';
import fs from 'fs'
import path from 'path'

const app = Fastify 
	logger: { prettyPrint: true, prettifier },
	disableRequestLogging: true

def start
	const closeDatabasePool = await initDatabase!
	app.register fastifyRequestLogger
	app.register fastifySession,
		cookieName: "my-cookie"
		key: fs.readFileSync path.join(__dirname, '../', 'secret-key')
		cookie:
			path: '/'
	app.register flash
	const ASSET_VERSION = "1"
	def _html pageObject, viewData
		String index.body.replace ",,,", JSON.stringify pageObject


	app.register inertia,
		version: ASSET_VERSION
		html: _html
		flashMessages: do(req, reply) reply.flash!

	app.register LoginController,
		prefix: "/login"
	

	app.addHook "preHandler", do(req, reply, next)
		const user = req.session.get("user");
		if user 
			req.Inertia.shareProps
				auth:
					user: user
				requestId: Math.random()
			return next!
		# console.log req.session
		req.Inertia.redirect "/login" unless req.url === "/login"
		next!


	app.register OrganizationsController,
		prefix:"/organizations"

	app.register ContactsController,
		prefix:"/contacts"

	app.register UsersController,
		prefix:"/users"


	app.route
		method: "GET"
		url: "/"
		handler: do(req, reply)
			req.Inertia.render
				component: "dashboard-page"

	try
		await app.listen(3000)
		imba.serve app.server
	catch err
		app.log.error err
		closeDatabasePool!
		process.exit 1
	
start!