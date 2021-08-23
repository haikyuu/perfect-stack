import { Inertia, mergeDataIntoQueryString, shouldIntercept } from '@inertiajs/inertia'

const noop = do() undefined

tag inertia-link
	prop as = "a"
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
		if as === 'a' and method !== 'get'
			console.warn(`Creating POST/PUT/PATCH/DELETE <a> links is discouraged as it causes "Open Link in New Tab/Window" accessibility issues.\n\nPlease specify a more appropriate element using the "_as" attribute. For example:\n\n<inertia-link href="{href}" method="{method}" using="button">`)

		<self>
			switch self.as
				when 'a'
					<a @click=_visit href=_href class=className>	<slot> _href
				when 'button'
					<button @click=_visit class=className>	<slot> _href
				else
					<{self.as} @click=_visit href=_href class=className>	<slot> _href
					
		
		
		
	