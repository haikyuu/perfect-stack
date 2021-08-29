import { Form } from 'imba-inertia-adapter'
import {Inertia} from "@inertiajs/inertia"

tag edit-contacts-page
	prop props
	def setup
		const {last_name = "", first_name = "", email = "", phone = "", address = "", city = "", region = "", country = "", postal_code = "", organization} = props.props.contact;
		self.form = new Form
			first_name: first_name
			last_name: last_name
			email: email
			phone: phone
			address: address
			city: city
			region: region
			country: country
			postal_code: postal_code
			organization: organization.id
	def destroy
		if window.confirm 'Are you sure you want to delete this contact?'
			Inertia.delete "/contacts/{props.props.contact.id}"

	def createRestore Inertia
		do() restore Inertia
	def restore Inertia
		if window.confirm 'Are you sure you want to restore this contact?' 
			console.log "restoring"
			Inertia.put "/contacts/{props.props.contact.id}/restore"
	def render
		const {contact} = props.props
		const contacts = contact.contacts or []
		<self>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl>
					<inertia-link .text-indigo-400.{'hover:text-indigo-600'} href="/contacts"> "Contacts"
					<span .text-indigo-400.font-medium> "/"
					props.props.contact.name
				
				if contact.deleted_at	
					<trashed-message .mb-6 restore=createRestore(Inertia)> "This contact has been deleted."
				
				<div .bg-white.rounded-md.shadow.overflow-hidden.max-w-3xl>
					<form @submit.prevent=form.put("/contacts/{contact.id}")>
						<div .p-8.{'-mr-6'}.{'-mb-8'}.flex.flex-wrap>
							<text-input bind=form.data.first_name error=form.errors.first_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="First Name">
							<text-input bind=form.data.last_name error=form.errors.last_name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Last Name">
							<text-input bind=form.data.email error=form.errors.email .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Email">
							<text-input bind=form.data.phone error=form.errors.phone .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Phone">
							<text-input bind=form.data.address error=form.errors.address .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Address">
							<text-input bind=form.data.city error=form.errors.city .pr-6.pb-8.w-full.{'lg:w-1/2'} label="City">
							<text-input bind=form.data.region error=form.errors.region .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Province/State">
							<select-input bind=form.data.country error=form.errors.country .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Country">
								<option value="null">
								<option value="MA"> "Morocco"
								<option value="NOR"> "Norway"
							<select-input bind=form.data.organization error=form.errors.country .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Organization">
								for org in props.props.organizations
									<option value=org.id> org.name	
							<text-input bind=form.data.postal_code error=form.errors.postal_code .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Postal code">
						
						<div .px-8.py-4.bg-gray-50.border-t.border-gray-100.flex.items-center>
							if !contact.deleted_at
								<button .text-red-600.{'hover:underline'} tabindex="-1" type="button" @click=destroy> "Delete Contact"
							<loading-button loading=form.processing .btn-indigo.ml-auto type="submit"> "Update Contact"