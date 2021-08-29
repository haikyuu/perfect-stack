import { Form } from 'imba-inertia-adapter'
import {Inertia} from "@inertiajs/inertia"

tag edit-users-page
	prop props
	def setup
		const {first_name = "", last_name = "", email = "", password = "", photo_path = "", owner = "false"} = props.props.user;
		self.form = new Form
			first_name: first_name
			last_name: last_name
			email: email
			password: password
			photo: {name: photo_path}
			owner: owner
	def destroy
		if window.confirm 'Are you sure you want to delete this user?'
			Inertia.delete "/users/{props.props.user.id}"

	def createRestore Inertia
		do() restore Inertia
	def restore Inertia
		if window.confirm 'Are you sure you want to restore this user?' 
			console.log "restoring"
			Inertia.put "/users/{props.props.user.id}/restore"
	def render
		const {user} = props.props
		const contacts = user.contacts or []
		<self>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl>
					<inertia-link .text-indigo-400.{'hover:text-indigo-600'} href="/users"> "Users"
					<span .text-indigo-400.font-medium> "/"
					props.props.user.name
				
				if user.deleted_at	
					<trashed-message .mb-6 restore=createRestore(Inertia)> "This user has been deleted."
				
				<div .bg-white.rounded-md.shadow.overflow-hidden.max-w-3xl>
					<form @submit.prevent=form.put("/users/{user.id}")>
						<div .p-8.{'-mr-6'}.{'-mb-8'}.flex.flex-wrap>
							<text-input bind=form.data.first_name error=form.errors.first_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="First Name">
							<text-input bind=form.data.last_name error=form.errors.last_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Last Name">
							<text-input bind=form.data.email error=form.errors.email .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Email">
							<text-input bind=form.data.password error=form.errors.email .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Password" type="password">
							<select-input bind=form.data.owner error=form.errors.owner .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Owner">
								<option value="false"> "No"
								<option value="true"> "Yes"
							<file-input value=form.data.photo onChange=(do(file) form.data.photo = file) error=form.errors.photo .pr-6.pb-8.w-full.{'lg:w-1/2'} accept="image/*" label="Photo" />

						<div .px-8.py-4.bg-gray-50.border-t.border-gray-100.flex.items-center>
							if !user.deleted_at
								<button .text-red-600.{'hover:underline'} tabindex="-1" type="button" @click=destroy> "Delete User"
							<loading-button loading=form.processing .btn-indigo.ml-auto type="submit"> "Update User"