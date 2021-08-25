tag select-input
	prop label\string
	prop error\string
	def render
		<self>
			if label
				<label .form-label for="id"> label
			<select id="id" bind=data .form-select .error=error>
				<slot />

			if error
				<div .form-error> error