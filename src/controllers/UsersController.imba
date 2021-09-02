import express from 'express'
import edgedb from 'edgedb'
import User from '../services/user'
import {FastifyInstance} from 'fastify'
import {getPaginationData} from '../utils/index.imba'

export default def UsersController(router\FastifyInstance, options, done)
	router.get "/" do(req, res)
		const {query} = req
		const {search = "", trashed,} = query
		const page = +query.page or 1
		const limit = 10;
		try
			const {users,total} = await User.getMultiple 
				"{search}",
				"{trashed}",
				page,
				limit
			const paginationData = getPaginationData
				{data: users, total, limit, query, url: "/users", page}
			req.Inertia.render
				component: "users-page"
				props:
					filters: 
						search: search
						trashed: trashed
					users: paginationData
		catch error
			console.log error
			req.flash "error", "Error fetching all users: {error}"
			req.Inertia.redirect("/")	
	router.get "/create" do(req, res)
		req.Inertia.render
			component: "create-users-page"

	router.get "/:id/edit" do(req, res)
		try
			const user = await User.getOne req.params.id
			req.Inertia.render
				component: "edit-users-page"
				props: 
					user: user
		catch error
			req.flash "error", "Error fetching user: {error}"
			req.Inertia.redirect("/users")

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
	router.put "/:id/restore" do(req, res)
		try
			await User.restore req.params.id
			req.flash "success", "user restored successfully"
			req.Inertia.redirect "/users/{req.params.id}/edit"
		catch error
			req.flash "error", "Error restoring user"
			req.Inertia.redirect "/users/{req.params.id}/edit"

	router.delete "/:id" do(req, res)
		try
			await User.delete req.params.id
			req.flash "success", "user deleted successfully"
			req.Inertia.redirect "/users/{req.params.id}/edit"
		catch error
			req.flash "error", "Error deleting user"
			req.Inertia.redirect "/users/{req.params.id}/edit"
	

	router.put "/:id" do(req, res)
		const {body} = req
		const data = {
			...body,
			email: body.email or ""
		}
		try
			await User.edit req.params.id, data
			req.flash "success", "User updated successfully"
			req.Inertia.redirect "/users/{req.params.id}/edit"
		catch error
			req.flash "error", "Error updating user: {error}"
			req.Inertia.redirect "/users/{req.params.id}/edit"
	
	router.post "/store" do(req, res)
		const {body, files} = req
		try
			await User.create { ...body, owner: !!body.owner, photo_path: files.photo.name}
			req.flash "success", "User created successfully"
			req.Inertia.redirect "/users"

		catch error
			req.flash "error", "Error creating user: {error}"
			req.Inertia.render
				component: "create-users-page"
	
	
					
	done!