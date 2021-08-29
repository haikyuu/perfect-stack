import { Form } from 'imba-inertia-adapter'

tag users-page
	prop props
	def setup
		const {filters, users} = props.props
		form = new Form
			search: filters.search
			trashed: filters.trashed
			current_page: users.current_page

	def onChange form
		const {search, trashed, page = 1} = form.data
		form.get "/users?search={search}&trashed={trashed}&page={page}", { preserveState: yes }
		
	def onChangeCreator form
		return do() onChange(form)
	def onResetCreator form
		do() 
			# form.reset! # resets to initial values ... we want to clear instead
			form.data.search = ""
			form.data.trashed = ""
			onChange form
	def render
		const {users} = props.props
		const {links} = users
		<self>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl> "Users"
				<div .mb-6.flex.justify-between.items-center>
					<search-filter filter=form.data.trashed bind=form.data.search .w-full.max-w-md.mr-4 reset=onResetCreator(form) _change=onChangeCreator(form)>
						<label[ta:start] .block.text-gray-700> "Trashed:"
						<select bind=form.data.trashed @change=onChange(form) .mt-1.w-full.form-select>
							<option value="">
							<option value="With Trashed"> "With Trashed"
							<option value="Only Trashed"> "Only Trashed"
						
					
					<inertia-link .btn-indigo href="/users/create">
						<span> "Create "
						<span .hidden.{'md:inline'}> "User"
					
				
				<div .bg-white.rounded-md.shadow.overflow-x-auto>
					<table .w-full.whitespace-nowrap>
						<tr .text-left.font-bold>
							<th .px-6.pt-6.pb-4> "Name"
							<th .px-6.pt-6.pb-4> "Email"
							<th .px-6.pt-6.pb-4 colspan="2"> "Role"
						for user in users.data
							<tr .{'hover:bg-gray-100'}.{'focus-within:bg-gray-100'}>
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center.{'focus:text-indigo-500'} href="/users/{user.id}/edit">
										user.name
										if users.deleted_at
											<icon name="trash" .flex-shrink-0.w-3.h-3.fill-gray-400.ml-2>
									
								
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/users/{user.id}/edit" tabIndex="-1">
										user.email
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/users/{user.id}/edit" tabIndex="-1">
										user.owner ? "Owner": "User"
									
								
								<td .border-t.w-px>
									<inertia-link .px-4.flex.items-center href="/users/{user.id}/edit" tabIndex="-1">
										<icon name="cheveron-right" .block.w-6.h-6.fill-gray-400 />
									
								
						if users.data.length === 0
							<tr>
								<td .border-t.px-6.py-4 colspan="4"> "No users found."
				
				<pagination .mt-6 links=links>