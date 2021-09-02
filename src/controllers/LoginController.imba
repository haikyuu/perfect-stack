import {checkPassword} from '../services/auth'
import edgedb from 'edgedb'
import {FastifyInstance} from 'fastify'

export default def LoginController(router\FastifyInstance, options, done)
	router.get "/" do(req, res)
		req.Inertia.render 
			component: "login-page"

	router.delete "/" do(req, res)
		req.session.set("user", null)
		req.Inertia.redirect "/"

	router.post "/" do(req, res)
		const {body} = req
		console.log body
		const conn = await edgedb!
		try
			const user = await conn.querySingle\<{id:string, owner:boolean, password:string, first_name:string, last_name:string}> `
				SELECT User \{ id, owner, password, first_name, last_name \} 
					FILTER
						NOT EXISTS .deleted_at AND
						.email = <str>$email
			`, email: body.email
			if checkPassword body.password, user.password
				let sessionUser = 
					id: user.id
					owner: user.owner
					first_name: user.first_name
					last_name: user.last_name
				req.session.set 'user', sessionUser
				return req.Inertia.redirect "/"
		catch error
			console.log "login", error.message
		
		req.Inertia.render
			component: "login-page"
			props:
				errors: 
					email: "These credentials do not match our records."

	done!