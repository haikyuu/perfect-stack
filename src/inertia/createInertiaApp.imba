import {InertiaApp} from './App'
import "./InertiaLink"

export default def createInertiaApp { id = 'app', resolve, setup, title, page, render }
	const isServer = typeof window === 'undefined'
	const el = isServer ? null : document.getElementById(id)
	const initialPage = page || JSON.parse(el.dataset.page)
	const resolveComponent = do(name) await name
	# Promise.resolve(resolve(name)).then do(module)
	# 	module.default or module

	let head = []

	const imbaApp = await resolveComponent(initialPage.component).then
		do(initialComponent)
			setup {
				el,
				App: InertiaApp,
				props: {
					initialPage,
					initialComponent,
					resolveComponent,
					titleCallback: title
					# onHeadUpdate: isServer ?
					# 	do elements
					# 		head = elements
					# : null
				},
			}


	# if (isServer) {
	# const body = await render(
	# 	createElement('div', {
	# 	id,
	# 	'data-page': JSON.stringify(initialPage),
	# 	}, reactApp)
	# )

	return { head, body }
	

