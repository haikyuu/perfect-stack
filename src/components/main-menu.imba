tag menu-link < inertia-link
	prop icon\string
	prop url\string

	def isUrl ...urls
		let currentUrl = #context.currentPage.page.url.substr 1
		if (urls[0] === '')
			return currentUrl === ''
		return Boolean urls.filter(do(url) currentUrl.startsWith url).length

	def render
		const isCurrentUrl = isUrl url
		<self[cursor:pointer] href=href .flex.items-center.group.py-3.mb-4>
			<icon name=icon .w-4.h-4.mr-2 .fill-white=isCurrentUrl .fill-indigo-400=!isCurrentUrl .{"group-hover:fill-white"}=!isCurrentUrl>
			<div .text-white=isCurrentUrl .text-indigo-300=!isCurrentUrl .{"group-hover:text-white"}=!isCurrentUrl>
				<slot>
					
tag main-menu
	def render
		<self>
			<menu-link icon="dashboard" href="/" url=""> "Dashboard"
			<menu-link icon="office" href="/organizations" url="organizations"> "Organizations"
			<menu-link icon="users" href="/contacts" url="contacts"> "Users"
			<menu-link icon="printer" href="/reports" url="reports"> "Reports"
			