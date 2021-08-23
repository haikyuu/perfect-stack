import {checkPassword} from '../services/auth'
import express from 'express'
import edgedb from 'edgedb'

export default def LoginController
	let router = express.Router!

	router.get "/" do(req, res)
		req.Inertia.render 
			component: "login-page"

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
				req.session.user = sessionUser
				return req.Inertia.redirect "/"
		catch error
			console.log "login", error.message
		
		req.Inertia.render
			component: "login-page"
			props:
				errors: 
					email: "These credentials do not match our records."

	return router