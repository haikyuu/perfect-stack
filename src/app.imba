import {createInertiaApp} from 'imba-inertia-adapter'

import './pages/index'
import './components/index'

createInertiaApp
	resolve: do(name) name
	setup: do({ el, App, props })
		imba.mount <{App} props=props>