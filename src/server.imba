import {createServer} from './server-app'

def runServer
	const server = await createServer!
	imba.serve server.listen process.env.PORT or 3000

runServer!