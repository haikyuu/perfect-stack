import { Form } from 'imba-inertia-adapter'

tag create-contacts-page
	prop props
	def setup
		// we go verbose to have vs code's completion
		self.form = new Form
			first_name: ""
			last_name: ""
			email: ""
			phone: ""
			address: ""
			city: ""
			region: ""
			country: ""
			postal_code: ""
			organization: ""

	def render
		<self[d:block]>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl>
					<inertia-link .text-indigo-400.{'hover:text-indigo-600'} href="/organizations"> "Organizations"
					<span[mx:1] .text-indigo-400.font-medium> "/"
					"Create"

				<div .bg-white.rounded-md.shadow.overflow-hidden.max-w-3xl>
					<form @submit.prevent=form.post("/contacts/store")>
						<div .p-8.{'-mr-6'}.{'-mb-8'}.flex.flex-wrap>
							<text-input bind=form.data.first_name error=form.errors.first_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="First Name">
							<text-input bind=form.data.last_name error=form.errors.last_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Last Name">
							<text-input bind=form.data.email error=form.errors.email .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Email">
							<text-input bind=form.data.phone error=form.errors.phone .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Phone">
							<text-input bind=form.data.address error=form.errors.address .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Address">
							<text-input bind=form.data.city error=form.errors.city .pr-6.pb-8.w-full.{'lg:w-1/2'} label="City">
							<text-input bind=form.data.region error=form.errors.region .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Province/State">
							<select-input bind=form.data.country error=form.errors.country .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Country">
								<option value=""> ""
								<option value="MA"> "Morocco"
								<option value="NOR"> "Norway"
							<select-input bind=form.data.organization error=form.errors.country .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Organization">
								<option value=""> ""
								for org in props.props.organizations
									<option value=org.id> org.name		
							<text-input bind=form.data.postal_code error=form.errors.postal_code .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Postal code">
						
						<div .px-8.py-4.bg-gray-50.border-t.border-gray-100.flex.justify-end.items-center>
							<loading-button loading=form.processing .btn-indigo type="submit"> "Create Contact"
						
					