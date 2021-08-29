import { Form } from 'imba-inertia-adapter'

tag create-users-page
	prop props
	def setup
		// we go verbose to have vs code's completion
		self.form = new Form
			first_name: ""
			last_name: ""
			email: ""
			password: ""
			photo: null
			owner: "false"

	def render
		console.log form.data.photo
		<self[d:block]>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl>
					<inertia-link .text-indigo-400.{'hover:text-indigo-600'} href="/users"> "Users"
					<span[mx:1] .text-indigo-400.font-medium> "/"
					"Create"

				<div .bg-white.rounded-md.shadow.overflow-hidden.max-w-3xl>
					<form @submit.prevent=form.post("/users/store")>
						<div .p-8.{'-mr-6'}.{'-mb-8'}.flex.flex-wrap>
							<text-input bind=form.data.first_name error=form.errors.first_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="First Name">
							<text-input bind=form.data.last_name error=form.errors.last_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Last Name">
							<text-input bind=form.data.email error=form.errors.email .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Email">
							<text-input bind=form.data.password error=form.errors.email .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Password" type="password">
							<file-input value=form.data.photo onChange=(do(file) form.data.photo = file) error=form.errors.photo .pr-6.pb-8.w-full.{'lg:w-1/2'} accept="image/*" label="Photo" />

							<select-input bind=form.data.owner error=form.errors.owner .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Owner">
								<option value="false"> "No"
								<option value="true"> "Yes"
						<div .px-8.py-4.bg-gray-50.border-t.border-gray-100.flex.justify-end.items-center>
							<loading-button loading=form.processing .btn-indigo type="submit"> "Create User"
						
					