tag menu-link < inertia-link
	prop icon\string
	prop url\string
	constructor ...props
		super props
	

	def render
		const isCurrentUrl = isUrl url
		<self[cursor:pointer] href=href .flex.items-center.group.py-3.mb-4>
			<icon name=icon .w-4.h-4.mr-2 .fill-white=isCurrentUrl .fill-indigo-400=!isCurrentUrl .{"group-hover:fill-white"}=!isCurrentUrl>
			<div .text-white=isCurrentUrl .text-indigo-300=!isCurrentUrl .{"group-hover:text-white"}=!isCurrentUrl>
				<slot>

const menuItems = [
	{icon:"dashboard", href:"/" ,url:"", label:"Dashboard"}
	{icon:"office", href:"/organizations" ,url:"organizations", label:"Organizations"}
	{icon:"users", href:"/contacts" ,url:"contacts", label:"Contacts"}
	{icon:"printer", href:"/reports" ,url:"reports", label:"Reports"}
]		
tag main-menu
	def isUrl ...urls
		console.log #context.currentPage
		let currentUrl = #context.currentPage.page.url.substr 1
		if (urls[0] === '')
			return currentUrl === ''
		return Boolean urls.filter(do(url) currentUrl.startsWith url).length
	def render
		<self>
			for {icon, href, url, label} of menuItems
				const isCurrentUrl = isUrl url
				<inertia-link[cursor:pointer] href=href .flex.items-center.group.py-3.mb-4>
					<icon name=icon .w-4.h-4.mr-2 .fill-white=isCurrentUrl .fill-indigo-400=!isCurrentUrl .{"group-hover:fill-white"}=!isCurrentUrl>
					<div .text-white=isCurrentUrl .text-indigo-300=!isCurrentUrl .{"group-hover:text-white"}=!isCurrentUrl>
						label