import {db} from './db'
class User
	def restore id\string
		const args = {id,}
		console.time("restore user")
		await db.query `
				UPDATE User
				FILTER .id = <uuid>$id 
				SET \{ deleted_at := <datetime>\{} }
		`, args
		console.timeEnd("restore user")
	
	def delete id\string
		const args = {id}
		console.time("delete user")
		await db.query `
				UPDATE User
				FILTER .id = <uuid>$id 
				SET \{ deleted_at := datetime_current() }
		`, args
		console.timeEnd("delete user")
	def getOne id\string
		const args = {id}
		console.time("get one user")
		const [org] = await db.query `
				SELECT User \{
					id, first_name, last_name, name, email ,owner, photo_path,
					deleted_at
				}
				FILTER .id = <uuid>$id
			`, args
		console.timeEnd("get one user")
		org
	def edit id\string, body
		const args = {
			...body,
			id,
		}
		console.time("edit user")
		await db.query `
			UPDATE User
			FILTER .id = <uuid>$id
			SET \{
				first_name := <str>$first_name,
				last_name := <str>$last_name,
				email := <str>$email,
				password := <str>$password,
				owner := <bool>$owner,
				photo_path := <str>$photo_path
			}
		`, args
		console.timeEnd("edit user")
	def create body
		const args = body
		await db.query `
			INSERT User \{
				first_name := <str>$first_name,
				last_name := <str>$last_name,
				email := <str>$email,
				password := <str>$password,
				owner := <bool>$owner,
				photo_path := <str>$photo_path
			}
		`, args
	def getMultiple search\string, trashed\string, page\number, limit\number
		console.time "get multiple users"
		let filterQuery = 'NOT EXISTS User.deleted_at'
		if trashed === "Only Trashed"
			filterQuery = `EXISTS User.deleted_at`
		else if trashed === "With Trashed"
			filterQuery = `TRUE`

		
		let offset = (+page - 1) * limit;
		const args = {
			search,
			offset,
			limit,
		}
		const result = await db.query `
			WITH _users := 
				(
					SELECT User FILTER 
							contains( str_lower(User.name), str_lower(<str>$search) ) AND
							{filterQuery}
				)
			SELECT \{
				users := (
					SELECT _users \{
						id, name, email, owner	
					}
						ORDER BY .created_at ASC
						OFFSET <int64>$offset
						LIMIT <int64>$limit
				),
				total := count(_users)
			}
		`, args
		const [{users, total}] = result
		console.timeEnd("get multiple users")
		return {users, total}

export default new User