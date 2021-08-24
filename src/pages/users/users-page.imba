# import 'imba/reset.css'
import { Inertia } from '@inertiajs/inertia'
import Form from '../../inertia/Form'

tag users-page
	prop props\{props: {people: \{first_name: string, last_name: string, id: string}[]}}
		
	def setup do
		self.form = new Form
			first_name: 'Abdellah',
			last_name: 'Alaoui'

	def deletePerson id
		Inertia.delete "/people?id={id}"
	def render
		<self>
			<h1> String form.processing
			<inertia-link href="/movies"> "movies"
			<div[c:blue6]> "Welcome!"
			<div> "Url is {document.location.href}"
			<ul> for person in props.props.people
				<li>
					<span> "person: {person.id} {person.first_name}  {person.last_name}"
					<button @click=deletePerson(person.id)> "delete"
			<h1> "Create a Person"
			<form>
				<input type="text" bind=form.data.first_name>
				<input type="text" bind=form.data.last_name>
				<button type="button" @click=form.post("/people")> "submit"
				<button type="button" @click=form.reset()> "reset"
