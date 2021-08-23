tag loading-button < button
	prop loading\boolean
	prop type\HTMLButtonElement["type"]

	def render
		<self [cursor:pointer] disabled=loading .flex.items-center type=type>
			if loading
				<div .btn-spinner.mr-2>
			else <slot>