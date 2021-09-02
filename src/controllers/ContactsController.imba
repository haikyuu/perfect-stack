import express from 'express'
import edgedb from 'edgedb'
import Contact from '../services/contact'
import Org from '../services/organization'
import {FastifyInstance} from 'fastify'
import {getPaginationData} from '../utils/index.imba'

export default def ContactsController(router\FastifyInstance, options, done)
	router.get "/" do(req, res)
		const {query} = req
		const {search = "", trashed,} = query
		const page = +query.page or 1
		const limit = 10;
		try
			const {contacts,total} = await Contact.getMultiple 
				req.session.get("user").id,
				"{search}",
				"{trashed}",
				page,
				limit
			const paginationData = getPaginationData
				{data: contacts, total, limit, query, url: "/contacts", page}
			req.Inertia.render
				component: "contacts-page"
				props:
					filters: 
						search: search
						trashed: trashed
					contacts: paginationData
		catch error
			console.log error
			req.flash "error", "Error fetching all contacts: {error}"
			req.Inertia.redirect("/")	
	router.get "/create" do(req, res)
		try
			const allOrgs = await Org.getAll!
			req.Inertia.render
				component: "create-contacts-page"
				props:
					organizations: allOrgs
		catch error
			req.flash "error", "Error fetching all organizations for contact: {error}"
			req.Inertia.redirect("/contacts")


	router.get "/:id/edit" do(req, res)
		try
			const contact = await Contact.getOne req.params.id, req.session.get("user").id
			const allOrgs = await Org.getAll!
			req.Inertia.render
				component: "edit-contacts-page"
				props: 
					contact: contact
					organizations: allOrgs
		catch error
			req.flash "error", "Error fetching contact: {error}"
			req.Inertia.redirect("/contacts")

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
	router.put "/:id/restore" do(req, res)
		try
			await Contact.restore req.params.id, req.session.get("user").id
			req.flash "success", "contact restored successfully"
			req.Inertia.redirect "/contacts/{req.params.id}/edit"
		catch error
			req.flash "error", "Error restoring contact"
			req.Inertia.redirect "/contacts/{req.params.id}/edit"

	router.delete "/:id" do(req, res)
		try
			await Contact.delete req.params.id, req.session.get("user").id
			req.flash "success", "contact deleted successfully"
			req.Inertia.redirect "/contacts/{req.params.id}/edit"
		catch error
			req.flash "error", "Error deleting contact"
			req.Inertia.redirect "/contacts/{req.params.id}/edit"
	

	router.put "/:id" do(req, res)
		const {body} = req
		const data = {
			...body,
			email: body.email or ""
		}
		try
			await Contact.edit req.params.id, req.session.get("user").id, data
			req.flash "success", "Contact updated successfully"
			req.Inertia.redirect "/contacts/{req.params.id}/edit"
		catch error
			req.flash "error", "Error updating contact: {error}"
			req.Inertia.redirect "/contacts/{req.params.id}/edit"
	
	router.post "/store" do(req, res)
		const {body} = req
		try
			await Contact.create req.session.get("user").id, body
			req.flash "success", "Contact created successfully"
			req.Inertia.redirect "/contacts"

		catch error
			req.flash "error", "Error creating contact: {error}"
			req.Inertia.render
				component: "create-contacts-page"
	
	
	done!
