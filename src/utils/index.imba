export def getPaginationData args\{data:any[], limit: number, query:Object, url:string, total:number, page:number}
	const {data, limit, query, url, total, page} = args
	const lastPage = Math.ceil total / limit
	def getPage(_url, page) 
		`{_url}?{String(new URLSearchParams { ...query, page: page })}`
	def getDataPage page
		getPage url, page

	let links = []
	for num in [0 .. lastPage + 1]
		let label = num
		let url = getDataPage num
		if num === 0
			label = "&laquo; Previous"
			if page === 1
				url = ""
			else
				url = getDataPage +page - 1
		else if num === lastPage + 1
			label = "Next &raquo;"
			if page === lastPage
				url = ""
			else
				url = getDataPage +page + 1
		links.push 
			url: url
			label: label
			active: num === +page
	
		return {
			page
			data
			first_page_url: getDataPage(0)
			from: 0
			last_page: lastPage
			last_page_url: getDataPage(lastPage)
			next_page_url: getDataPage(+page + 1)
			path: url
			per_page: limit
			prev_page_url: null
			to: lastPage
			total: total
			links: links
		}
