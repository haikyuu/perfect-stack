# import { useEffect, useState } from 'react'
import { Inertia } from '@inertiajs/inertia'

# export default def useRemember initialState, key
# 	console.log initialState, key
# 	return initialState

export default class Remembered
	constructor initialState, _key
		const restored = Inertia.restore key
		state = restored !== undefined ? restored : initialState
		key = _key
# export default function useRemember2(initialState, key) {
#   const [state, setState] = useState(() => {
#     const restored = Inertia.restore(key)

#     return restored !== undefined ? restored : initialState
#   })

#   useEffect(() => {
#     Inertia.remember(state, key)
#   }, [state, key])

#   return [state, setState]
# }

# export function useRememberedState(initialState, key) {
#   console.warn('The "useRememberedState" hook has been deprecated and will be removed in a future release. Use "useRemember" instead.')
#   return useRemember(initialState, key)
# }
