import {db} from './db'
class Organization
	def getAll
		console.time "get all orgs"
		const orgs = await db.query `SELECT Organization \{id, name}`
		console.timeEnd "get all orgs"
		return orgs
	def restore id\string, userId\string
		const args = {id, userId}
		console.time("restore org")
		await db.query `
				UPDATE Organization
				FILTER .id = <uuid>$id 
				AND .account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
					)
				SET \{ deleted_at := <datetime>\{} }
		`, args
		console.timeEnd("restore org")
	
	def delete id\string, userId\string
		const args = {id, userId}
		console.time("delete org")
		await db.query `
				UPDATE Organization
				FILTER .id = <uuid>$id 
				AND .account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
					)
				SET \{ deleted_at := datetime_current() }
		`, args
		console.timeEnd("delete org")
	def getOne id\string, userId\string
		const args = {id, userId}
		console.time("get one org")
		const [org] = await db.query `
				SELECT Organization \{
					id, name, email,phone,address,city,region,country,postal_code, deleted_at,
					account:\{ id },
					contacts:= .<organization[IS Contact] \{name, city, phone, id, deleted_at}
				}
				FILTER 	.account = (
						SELECT User FILTER
							User.id = <uuid>$userId AND
							NOT EXISTS .deleted_at
						)
					AND .id = <uuid>$id
			`, args
		console.timeEnd("get one org")
		org
	def edit id\string, userId\string, body
		const args = {
			...body,
			id,
			userId
		}
		console.time("edit org")
		await db.query `
			UPDATE Organization
			FILTER .id = <uuid>$id 
			AND .account = (
					SELECT User FILTER
						User.id = <uuid>$userId AND
						NOT EXISTS .deleted_at
				)
			SET \{
				name := <str>$name,
				email := <str>$email,
				phone := <str>$phone,
				address := <str>$address,
				city := <str>$city,
				region := <str>$region,
				country := <str>$country,
				postal_code := <str>$postal_code
			}
		`, args
		console.timeEnd("edit org")
	def create userId\string, body
		const args = {
			...body,
			userId
		}
		console.time("create org")
		await db.query `
			INSERT Organization \{
				name := <str>$name,
				email := <str>$email,
				phone := <str>$phone,
				address := <str>$address,
				city := <str>$city,
				region := <str>$region,
				country := <str>$country,
				postal_code := <str>$postal_code,
				account := (SELECT User FILTER User.id = <uuid>$userId)
			}
		`, args
		console.timeEnd("create org")
	def getMultiple userId\string, search\string, trashed\string, page\number, limit\number
		console.time("get multiple orgs")
		let offset = (+page - 1) * limit;
		const args = {
			userId,
			offset,
			limit,
		}

		let filterQuery = 'NOT EXISTS Organization.deleted_at'
		if trashed === "Only Trashed"
			filterQuery = `EXISTS Organization.deleted_at`
		else if trashed === "With Trashed"
			filterQuery = `TRUE`
		
		if search
			filterQuery += "AND contains( str_lower(Organization.name), str_lower(<str>$search) )"
			args.search = search
		
		console.log filterQuery
		const result = await db.query `
			WITH orgs := 
				(
					SELECT Organization FILTER 
							.account = (
								SELECT User FILTER
									User.id = <uuid>$userId AND
									NOT EXISTS .deleted_at
								)  AND
							{filterQuery}
				)
			SELECT \{
				organizations := (
					SELECT orgs \{
						id, name, city, phone, deleted_at	
					}
						ORDER BY .created_at ASC
						OFFSET <int64>$offset
						LIMIT <int64>$limit
				),
				total := count(orgs)
			}
		`, args
		const [{organizations, total}] = result
		console.log result
		console.timeEnd("get multiple orgs")
		return {organizations, total}

export default new Organization