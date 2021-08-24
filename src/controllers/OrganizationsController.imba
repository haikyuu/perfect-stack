import express from 'express'
import edgedb from 'edgedb'
import {performance} from 'perf_hooks'

export default def OrganizationsController
	let router = express.Router!

	router.get "/" do(req, res)
		console.time("get orgs")
		const conn = await edgedb!
		const {search = "", trashed} = req.query
		let filterQuery = 'NOT EXISTS User.deleted_at'
		if trashed === 'only'
			filterQuery = `EXISTS User.deleted_at`
		else if trashed === 'with'
			filterQuery = `TRUE`

		const queryArgs = 
			userId: req.session.user.id
			search: search
		console.log queryArgs

		const organizations = await conn.query `
			SELECT Organization\{
				id, name, city, phone, deleted_at	
			\} FILTER 
			   		.account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
						) AND 
					contains( str_lower(Organization.name), str_lower(<str>$search) ) AND
					{filterQuery}
		`, queryArgs

		console.timeEnd("get orgs")
		req.Inertia.render
			component: "organizations-page"
			props:
				filters: 
					search: null
					trashed: null
				organizations:
					current_page: 1
					data: organizations
					first_page_url: "/organizations?trashed=with&page=1"
					from: 1
					last_page: 10
					last_page_url: "/organizations?trashed=with&page=10"
					links: [
						{
							url: null
							label: "&laquo; Previous"
							active: false
						}
						{
							active: true
							label: "1"
							url: "/organizations?trashed=with&page=1"
						}
					]
					next_page_url: "/organizations?trashed=with&page=2"
					path: "/organizations"
					per_page: 10
					prev_page_url: null
					to: 10
					total: 100