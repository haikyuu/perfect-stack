tag teleport
	prop to\string # a query selector string: where to put 
	prop disabled\boolean
	def mount
		const destination = document.querySelector to
		# console.log destination
	def render
		<self>
			<slot>