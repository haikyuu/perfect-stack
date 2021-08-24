import Form from '../../inertia/Form'

tag organizations-page
	def setup
		form = new Form
			search: ""
			trashed: ""

	def onChange form
		const {search, trashed} = form.data
		console.log "onchange", search, trashed
		form.get "/organizations?search={search}&trashed={trashed}", { preserveState: yes }
		
	def onChangeCreator form
		return do() onChange(form)
	def onResetCreator form
		do() 
			console.log "reset"
			form.reset!
			onChange form
	def render
		const organizations = #context.currentPage.page.props.organizations
		<self>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl> "Organizations"
				<div .mb-6.flex.justify-between.items-center>
					<search-filter bind=form.data.search .w-full.max-w-md.mr-4 reset=onResetCreator(form) _change=onChangeCreator(form)>
						<label[ta:start] .block.text-gray-700> "Trashed:"
						<select bind=form.data.trashed @change=onChange(form) .mt-1.w-full.form-select>
							<option value="">
							<option value="with"> "With Trashed"
							<option value="only"> "Only Trashed"
						
					
					<inertia-link .btn-indigo :href="route('organizations.create')">
						<span> "Create"
						<span .hidden.{'md:inline'}> "Organization"
					
				
				<div .bg-white.rounded-md.shadow.overflow-x-auto>
					<table .w-full.whitespace-nowrap>
						<tr .text-left.font-bold>
							<th .px-6.pt-6.pb-4> "Name"
							<th .px-6.pt-6.pb-4> "City"
							<th .px-6.pt-6.pb-4 colspan="2"> "Phone"
						for organization in organizations.data
							<tr .{'hover:bg-gray-100'}.{'focus-within:bg-gray-100'}>
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center.{'focus:text-indigo-500'} href="/organizations/{organization.id}/edit">
										organization.name
										if organizations.deleted_at
											<icon name="trash" .flex-shrink-0.w-3.h-3.fill-gray-400.ml-2>
									
								
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/organizations/{organization.id}/edit" tabIndex="-1">
										organization.city	
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center :href="/organizations/{organization.id}/edit" tabIndex="-1">
										organization.phone
									
								
								<td .border-t.w-px>
									<inertia-link .px-4.flex.items-center :href="/organizations/{organization.id}/edit" tabIndex="-1">
										<icon name="cheveron-right" .block.w-6.h-6.fill-gray-400 />
									
								
						if organizations.data.length === 0
							<tr>
								<td .border-t.px-6.py-4 colspan="4"> "No organizations found."
						
					
				
				<pagination .mt-6 links=organizations.links>