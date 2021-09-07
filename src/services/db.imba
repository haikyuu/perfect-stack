import * as edgedb from 'edgedb'
import {Pool} from 'edgedb'

let db\Pool

def initDatabase
	# @ts-ignore
	db = await edgedb.createPool {database:process.env.EDGEDB_DATABASE}
	return do() db.close

export {initDatabase, db}