import {db} from './db'
class Contact
	def restore id\string, userId\string
		const args = {id, userId}
		console.time("restore contact")
		await db.query `
				UPDATE Contact
				FILTER .id = <uuid>$id 
				AND .account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
					)
				SET \{ deleted_at := <datetime>\{} }
		`, args
		console.timeEnd("restore contact")
	
	def delete id\string, userId\string
		const args = {id, userId}
		console.time("delete contact")
		await db.query `
				UPDATE Contact
				FILTER .id = <uuid>$id 
				AND .account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
					)
				SET \{ deleted_at := datetime_current() }
		`, args
		console.timeEnd("delete contact")
	def getOne id\string, userId\string
		const args = {id, userId}
		console.time("get one contact")
		const [org] = await db.query `
				SELECT Contact \{
					id,organization :\{id}, first_name, last_name, name, email,phone,address,city,region,country,postal_code, deleted_at, account:\{ id }
				}
				FILTER 	.account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
						)
					AND .id = <uuid>$id
			`, args
		console.timeEnd("get one contact")
		org
	def edit id\string, userId\string, body
		const args = {
			...body,
			id,
			userId
		}
		console.time("edit contact")
		await db.query `
			UPDATE Contact
			FILTER .id = <uuid>$id 
			AND .account = (
					SELECT User FILTER
						User.id = <uuid>$userId AND
						NOT EXISTS .deleted_at
				)
			SET \{
				first_name := <str>$first_name,
				last_name := <str>$last_name,
				email := <str>$email,
				phone := <str>$phone,
				address := <str>$address,
				city := <str>$city,
				region := <str>$region,
				country := <str>$country,
				postal_code := <str>$postal_code,
				organization := (SELECT Organization FILTER Organization.id = <uuid>$organization)
			}
		`, args
		console.timeEnd("edit contact")
	def create userId\string, body
		const args = {
			...body,
			userId
		}
		await db.query `
			INSERT Contact \{
				first_name := <str>$first_name,
				last_name := <str>$last_name,
				email := <str>$email,
				phone := <str>$phone,
				address := <str>$address,
				city := <str>$city,
				region := <str>$region,
				country := <str>$country,
				postal_code := <str>$postal_code,
				account := (SELECT User FILTER User.id = <uuid>$userId),
				organization := (SELECT Organization FILTER Organization.id = <uuid>$organization)
			}
		`, args
	def getMultiple userId\string, search\string, trashed\string, page\number, limit\number
		console.time "get multiple contacts"
		let filterQuery = 'NOT EXISTS Contact.deleted_at'
		if trashed === "Only Trashed"
			filterQuery = `EXISTS Contact.deleted_at`
		else if trashed === "With Trashed"
			filterQuery = `TRUE`

		console.log trashed, filterQuery
		
		let offset = (+page - 1) * limit;
		const args = {
			userId,
			search,
			offset,
			limit,
		}
		const result = await db.query `
			WITH _contacts := 
				(
					SELECT Contact FILTER 
							.account = (
								SELECT User FILTER
									User.id = <uuid>$userId AND
									NOT EXISTS .deleted_at
								) AND 
							contains( str_lower(Contact.name), str_lower(<str>$search) ) AND
							{filterQuery}
				)
			SELECT \{
				contacts := (
					SELECT _contacts \{
						id, name, city, phone, deleted_at, organization :\{name}	
					}
						ORDER BY .created_at ASC
						OFFSET <int64>$offset
						LIMIT <int64>$limit
				),
				total := count(_contacts)
			}
		`, args
		const [{contacts, total}] = result
		console.timeEnd("get multiple contacts")
		return {contacts, total}

export default new Contact