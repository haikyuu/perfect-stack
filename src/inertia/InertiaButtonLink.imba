import { Inertia, mergeDataIntoQueryString, shouldIntercept } from '@inertiajs/inertia'

const noop = do() undefined

tag inertia-button-link < button
	prop data\object = {}
	prop href\string
	prop method\"get"|"post"|"patch"|"put"|"delete" = "get"
	prop preserveScroll = false
	prop preserveState\boolean|((p:any)=>boolean) = false
	prop replace = false
	prop only\string[] = []
	prop headers\object = {}
	prop onClick = noop
	prop onCancelToken = noop
	prop onBefore = noop
	prop onStart = noop
	prop onProgress = noop
	prop onFinish = noop
	prop onCancel = noop
	prop onSuccess = noop
	prop onError = noop

	def render
		const _visit = do(event)
			onClick event

			if shouldIntercept event
				event.preventDefault()

			Inertia.visit href, 
				data: data
				# @ts-ignore
				method: method
				preserveScroll: preserveScroll
				preserveState: preserveState ?? (method !== 'get')
				replace: replace
				only: only
				headers: headers
				onCancelToken: onCancelToken
				onBefore: onBefore
				onStart: onStart
				onProgress: onProgress
				onFinish: onFinish
				onCancel: onCancel
				onSuccess: onSuccess
				onError: onError
		# as = as.toLowerCase!
		# @ts-ignore
		const [_href, _data] = mergeDataIntoQueryString(method, href || '', data)
		href = _href
		data = _data

		<self @click=_visit class=className type="button">	<slot> _href