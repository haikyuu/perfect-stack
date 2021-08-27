import * as edgedb from 'edgedb'
import {Pool} from 'edgedb'

let db\Pool

def initDatabase
	db = await edgedb.createPool!
	return do() db.close

export {initDatabase, db}