import * as edgedb from 'edgedb'
import {Pool} from 'edgedb'

let db\Pool

def initDatabase
	db = await edgedb.createPool {connectOptions: {database:process.env.EDGEDB_DATABASE} }
	return do() db.close

export {initDatabase, db}