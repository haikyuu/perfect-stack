import Form from '../../inertia/Form'
import {Inertia} from "@inertiajs/inertia"

tag edit-organizations-page
	prop props
	def setup
		console.log props
		const {name = "", email = "", phone = "", address = "", city = "", region = "", country = "", postal_code = ""} = props.props.organization;
		self.form = new Form
			name: name
			email: email
			phone: phone
			address: address
			city: city
			region: region
			country: country
			postal_code: postal_code
	def destroy
		if window.confirm 'Are you sure you want to delete this organization?'
			Inertia.delete "/organizations/{props.props.organization.id}"

	def createRestore Inertia
		do() restore Inertia
	def restore Inertia
		if window.confirm 'Are you sure you want to restore this organization?' 
			console.log "restoring"
			Inertia.put "/organizations/{props.props.organization.id}/restore"
	def render
		const {organization} = props.props
		const contacts = organization.contacts or []
		<self>
			<page-layout>
				<h1 .mb-8.font-bold.text-3xl>
					<inertia-link .text-indigo-400.{'hover:text-indigo-600'} href="/organizations"> "Organizations"
					<span .text-indigo-400.font-medium> "/"
					form.data.name
				
				if organization.deleted_at	
					<trashed-message .mb-6 restore=createRestore(Inertia)> "This organization has been deleted."
				
				<div .bg-white.rounded-md.shadow.overflow-hidden.max-w-3xl>
					<form @submit.prevent=form.put("/organizations/{organization.id}")>
						<div .p-8.{'-mr-6'}.{'-mb-8'}.flex.flex-wrap>
							<text-input bind=form.data.name error=form.errors.name .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Name">
							<text-input bind=form.data.email error=form.errors.email .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Email">
							<text-input bind=form.data.phone error=form.errors.phone .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Phone">
							<text-input bind=form.data.address error=form.errors.address .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Address">
							<text-input bind=form.data.city error=form.errors.city .pr-6.pb-8.w-full.{'lg:w-1/2'} label="City">
							<text-input bind=form.data.region error=form.errors.region .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Province/State">
							<select-input bind=form.data.country error=form.errors.country .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Country">
								<option value="null">
								<option value="MA"> "Morocco"
								<option value="NOR"> "Norway"
							
							<text-input bind=form.data.postal_code error=form.errors.postal_code .pr-6.pb-8.w-full.{'lg:w-1/2'} label="Postal code">
						
						<div .px-8.py-4.bg-gray-50.border-t.border-gray-100.flex.items-center>
							if !organization.deleted_at
								<button .text-red-600.{'hover:underline'} tabindex="-1" type="button" @click=destroy> "Delete Organization"
							<loading-button loading=form.processing .btn-indigo.ml-auto type="submit"> "Update Organization"
				
				<h2 .mt-12.font-bold.text-2xl> "Contacts"
				<div .mt-6.bg-white.rounded.shadow.overflow-x-auto>
					<table .w-full.whitespace-nowrap>
						<tr .text-left.font-bold>
							<th .px-6.pt-6.pb-4> "Name"
							<th .px-6.pt-6.pb-4> "City"
							<th .px-6.pt-6.pb-4 colspan="2"> "Phone"
						for contact in contacts
							<tr .{'hover:bg-gray-100'}.{'focus-within:bg-gray-100'}>
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center.{'focus:text-indigo-500'} href="/contacts/{contact.id}/edit">
										contact.name
										if contact.deleted_at
											<icon name="trash" .flex-shrink-0.w-3.h-3.fill-gray-400.ml-2>
									
								
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/contacts/{contact.id}/edit" tabindex="-1">
										contact.city
									
								
								<td .border-t>
									<inertia-link .px-6.py-4.flex.items-center href="/contacts/{contact.id}/edit" tabindex="-1">
										contact.phone
									
								
								<td .border-t.w-px>
									<inertia-link .px-4.flex.items-center href="/contacts/{contact.id}/edit" tabindex="-1">
										<icon name="cheveron-right" .block.w-6.h-6.fill-gray-400>
									
								
							if organization.contacts.length === 0
								<tr>
									<td .border-t.px-6.py-4 colspan="4"> "No contacts found."
							
					
				