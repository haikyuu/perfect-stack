import express from 'express'
import edgedb from 'edgedb'
import {performance} from 'perf_hooks'

export default def OrganizationsController
	let router = express.Router!

	router.get "/" do(req, res)
		console.time("get orgs")
		const conn = await edgedb!
		const {query} = req
		const {search = "", trashed, page = 0} = query
		let filterQuery = 'NOT EXISTS User.deleted_at'
		if trashed === 'only'
			filterQuery = `EXISTS User.deleted_at`
		else if trashed === 'with'
			filterQuery = `TRUE`

		let limit = 10;
		let offset = +page * limit;
		const queryArgs = 
			userId: req.session.user.id
			search: search
			offset: offset
			limit: limit
		console.log queryArgs

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
			SELECT (
				organizations := (
					SELECT orgs \{
						id, name, city, phone, deleted_at	
					}
						ORDER BY .created_at ASC
						OFFSET <int64>$offset
						LIMIT <int64>$limit
				),
				total := count(orgs)
			)
		`, queryArgs
		# try
		# 	parsed = JSON.parse result
		let organizations = []
		let total = 0
		if result.length > 0
			organizations = result.map do(org) org.organizations
			total = result[0].total
		const lastPage = Math.ceil total / limit
		console.log "last", total, lastPage
		console.timeEnd("get orgs")
		console.log organizations
		def getPage(url, page) 
			`{url}?{String(new URLSearchParams { ...query, page: page })}`
		def getOrgPage page
			getPage '/organizations', page

		let links = []
		for num in [1 .. lastPage]
			let label = num
			if num === 1
				label = "&laquo; Previous"
			else if num === lastPage
				label = "Next &raquo;"
			links.push 
				url: getOrgPage num
				label: label
				active: num === page

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
					