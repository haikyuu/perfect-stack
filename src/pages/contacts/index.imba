import Form from '../../inertia/Form'

tag contacts-page
	prop props
	def setup
		const {filters, contacts} = props.props
		form = new Form
			search: filters.search
			trashed: filters.trashed
			current_page: contacts.current_page

	def onChange form
		const {search, trashed, page = 1} = form.data
		form.get "/contacts?search={search}&trashed={trashed}&page={page}", { preserveState: yes }
		
	def onChangeCreator form
		return do() onChange(form)
	def onResetCreator form
		do() 
			# form.reset! # resets to initial values ... we want to clear instead
			form.data.search = ""
			form.data.trashed = ""
			onChange form
	def render
		const {contacts} = props.props
		const {links} = contacts
		<self>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl> "Contacts"
				<div .mb-6.flex.justify-between.items-center>
					<search-filter filter=form.data.trashed bind=form.data.search .w-full.max-w-md.mr-4 reset=onResetCreator(form) _change=onChangeCreator(form)>
						<label[ta:start] .block.text-gray-700> "Trashed:"
						<select bind=form.data.trashed @change=onChange(form) .mt-1.w-full.form-select>
							<option value="">
							<option value="With Trashed"> "With Trashed"
							<option value="Only Trashed"> "Only Trashed"
						
					
					<inertia-link .btn-indigo href="/contacts/create">
						<span> "Create"
						<span .hidden.{'md:inline'}> "Contact"
					
				
				<div .bg-white.rounded-md.shadow.overflow-x-auto>
					<table .w-full.whitespace-nowrap>
						<tr .text-left.font-bold>
							<th .px-6.pt-6.pb-4> "Name"
							<th .px-6.pt-6.pb-4> "Organization"
							<th .px-6.pt-6.pb-4> "City"
							<th .px-6.pt-6.pb-4 colspan="2"> "Phone"
						for contact in contacts.data
							<tr .{'hover:bg-gray-100'}.{'focus-within:bg-gray-100'}>
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center.{'focus:text-indigo-500'} href="/contacts/{contact.id}/edit">
										contact.name
										if contacts.deleted_at
											<icon name="trash" .flex-shrink-0.w-3.h-3.fill-gray-400.ml-2>
									
								
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/contacts/{contact.id}/edit" tabIndex="-1">
										contact.organization.name	

								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/contacts/{contact.id}/edit" tabIndex="-1">
										contact.city

								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/contacts/{contact.id}/edit" tabIndex="-1">
										contact.phone
									
								
								<td .border-t.w-px>
									<inertia-link .px-4.flex.items-center href="/contacts/{contact.id}/edit" tabIndex="-1">
										<icon name="cheveron-right" .block.w-6.h-6.fill-gray-400 />
									
								
						if contacts.data.length === 0
							<tr>
								<td .border-t.px-6.py-4 colspan="4"> "No contacts found."
						
					
				
				<pagination .mt-6 links=links>