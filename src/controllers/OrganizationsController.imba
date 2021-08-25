import express from 'express'
import edgedb from 'edgedb'
import {performance} from 'perf_hooks'

export default def OrganizationsController
	let router = express.Router!

	router.get "/create" do(req, res)
		req.Inertia.render
			component: "create-organizations-page"

	router.put "/:id/restore" do(req, res)
		const conn = await edgedb!
		console.time "restore org"
		try
			await conn.query `
				UPDATE Organization
				FILTER .id = <uuid>$id 
				AND .account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
					)
				SET \{ deleted_at := <datetime>\{} }
			`, {id: req.params.id, userId: req.session.user.id}
			req.flash.setFlashMessage "success", "organization restored successfully"
			console.timeEnd "restore org"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
		catch error
			req.flash.setFlashMessage "error", "Error restoring organization"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"

	router.delete "/:id" do(req, res)
		const conn = await edgedb!
		console.time "delete org"
		try
			await conn.query `
				UPDATE Organization
				FILTER .id = <uuid>$id 
				AND .account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
					)
				SET \{ deleted_at := datetime_current() }
			`, {id: req.params.id, userId: req.session.user.id}
			req.flash.setFlashMessage "success", "organization deleted successfully"
			console.timeEnd "delete org"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
		catch error
			req.flash.setFlashMessage "error", "Error deleting organization"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
	router.get "/:id/edit" do(req, res)
		const conn = await edgedb!
		try
			const [org] = await conn.query `
				SELECT Organization \{
					id, name, email,phone,address,city,region,country,postal_code, deleted_at, account:\{ id }
				}
				FILTER 	.account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
						)
					AND .id = <uuid>$id
			`, 
				id: req.params.id
				userId: req.session.user.id
			console.log org
			req.Inertia.render
				component: "edit-organizations-page"
				props: 
					organization: org
		catch error
			req.flash.setFlashMessage "error", "Error fetching organization: {error}"
			req.Inertia.redirect("/organizations")

	router.put "/:id" do(req, res)
		console.time("update org")
		const conn = await edgedb!
		const {body} = req
		const params = {
			...body,
			email: body.email or ""
			userId: req.session.user.id
			id: req.params.id
		}
		try
			await conn.query `
				UPDATE Organization
				FILTER .id = <uuid>$id 
				AND .account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
					)
				SET \{
					name := <str>$name,
					email := <str>$email,
					phone := <str>$phone,
					address := <str>$address,
					city := <str>$city,
					region := <str>$region,
					country := <str>$country,
					postal_code := <str>$postal_code
				}
			`, params
			req.flash.setFlashMessage "success", "Organization updated successfully"
			console.timeEnd "update org"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"

		catch error
			req.flash.setFlashMessage "error", "Error updating organization: {error}"
			req.Inertia.redirect "/organizations/{req.params.id}/edit"
	
	router.post "/store" do(req, res)
		console.time("create org")
		const conn = await edgedb!
		const {body} = req
		const params = {
			...body,
			userId: req.session.user.id
		}
		try
			await conn.query `
				INSERT Organization \{
					name := <str>$name,
					email := <str>$email,
					phone := <str>$phone,
					address := <str>$address,
					city := <str>$city,
					region := <str>$region,
					country := <str>$country,
					postal_code := <str>$postal_code,
					account := (SELECT User FILTER User.id = <uuid>$userId)
				}
			`, params
			req.flash.setFlashMessage "success", "Organization created successfully"
			console.timeEnd "create org"
			req.Inertia.redirect "/organizations"

		catch error
			req.flash.setFlashMessage "error", "Error creating organization: {error}"
			req.Inertia.render
				component: "create-organizations-page"
	
	router.get "/" do(req, res)
		console.time("get orgs")
		const conn = await edgedb!
		const {query} = req
		const {search = "", trashed,} = query
		const page = +query.page or 1
		let filterQuery = 'NOT EXISTS Organization.deleted_at'
		if trashed === 'only'
			filterQuery = `EXISTS Organization.deleted_at`
		else if trashed === 'with'
			filterQuery = `TRUE`

		let limit = 10;
		let offset = (+page - 1) * limit;
		const queryArgs = 
			userId: req.session.user.id
			search: String search
			offset: offset
			limit: limit

		const result = await conn.query `
			WITH orgs := 
				(
					SELECT Organization FILTER 
							.account = (
								SELECT User FILTER
									User.id = <uuid>$userId AND
									NOT EXISTS .deleted_at
								) AND 
							contains( str_lower(Organization.name), str_lower(<str>$search) ) AND
							{filterQuery}
				)
			SELECT \{
				organizations := (
					SELECT orgs \{
						id, name, city, phone, deleted_at	
					}
						ORDER BY .created_at ASC
						OFFSET <int64>$offset
						LIMIT <int64>$limit
				),
				total := count(orgs)
			}
		`, queryArgs
		# try
		# 	parsed = JSON.parse result
		const [{organizations, total}] = result
		const lastPage = Math.ceil total / limit
		console.timeEnd("get orgs")
		def getPage(url, page) 
			`{url}?{String(new URLSearchParams { ...query, page: page })}`
		def getOrgPage page
			getPage '/organizations', page

		let links = []
		for num in [0 .. lastPage + 1]
			let label = num
			let url = getOrgPage num
			if num === 0
				label = "&laquo; Previous"
				if page === 1
					url = ""
				else
					url = getOrgPage +page - 1
			else if num === lastPage + 1
				label = "Next &raquo;"
				if page === lastPage
					url = ""
				else
					url = getOrgPage +page + 1
			links.push 
				url: url
				label: label
				active: num === +page

		req.Inertia.render
			component: "organizations-page"
			props:
				filters: 
					search: search
					trashed: trashed
				organizations:
					page: page
					data: organizations
					first_page_url: getOrgPage(0)
					from: 0
					last_page: lastPage
					last_page_url: getOrgPage(lastPage)
					next_page_url: getOrgPage(+page + 1)
					path: "/organizations"
					per_page: limit
					prev_page_url: null
					to: lastPage
					total: total
					links: links
					