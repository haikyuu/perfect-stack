import {getUsers} from '../services/users'
import express from 'express'

export default def UserController
	let router = express.Router!

	router.get "/" do(req, res)
		const users = await getUsers!
		req.Inertia.render 
			component: "users-page"
			props: 
				movies: users
	return router