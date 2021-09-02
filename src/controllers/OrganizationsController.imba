import express from 'express'
import edgedb from 'edgedb'
import {performance} from 'perf_hooks'
import Org from '../services/organization'
import {getPaginationData} from '../utils/index.imba'
import {FastifyInstance} from 'fastify'

export default def OrganizationsController(router\FastifyInstance, options, done)

	router.get "/" do(req, res)
		const {query} = req
		const {search = "", trashed,} = query
		const page = +query.page or 1
		const limit = 10;
		const {organizations,total} = await Org.getMultiple 
			req.session.get("user").id,
			"{search}",
			"{trashed}",
			page,
			limit
		const paginationData = getPaginationData
			{data: organizations, total, limit, query, url: "/organizations", page}
		req.Inertia.render
			component: "organizations-page"
			props:
				filters: 
					search: search
					trashed: trashed
				organizations: paginationData

	router.get "/create" do(req, res)
		req.Inertia.render
			component: "create-organizations-page"

	router.get "/:id/edit" do(req, res)
		try
			const org = await Org.getOne req.params.id, req.session.get("user").id
			req.Inertia.render
				component: "edit-organizations-page"
				props: 
					organization: org
		catch error
			req.flash "error", "Error fetching organization: {error}"
			req.Inertia.redirect("/organizations")

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
	router.put "/:id/restore" do(req, res)
		try
			await Org.restore req.params.id, req.session.get("user").id
			req.flash "success", "organization restored successfully"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
		catch error
			req.flash "error", "Error restoring organization"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"

	router.delete "/:id" do(req, res)
		try
			await Org.delete req.params.id, req.session.get("user").id
			req.flash "success", "organization deleted successfully"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
		catch error
			req.flash "error", "Error deleting organization"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
	

	router.put "/:id" do(req, res)
		const {body} = req
		const data = {
			...body,
			email: body.email or ""
		}
		try
			await Org.edit req.params.id, req.session.get("user").id, data
			req.flash "success", "Organization updated successfully"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
		catch error
			req.flash "error", "Error updating organization: {error}"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
	
	router.post "/store" do(req, res)
		const {body} = req
		try
			await Org.create req.session.get("user").id, body
			req.flash "success", "Organization created successfully"
			req.Inertia.redirect "/organizations"

		catch error
			req.flash "error", "Error creating organization: {error}"
			req.Inertia.render
				component: "create-organizations-page"
	
	
	done!