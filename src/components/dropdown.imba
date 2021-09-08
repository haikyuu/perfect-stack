# const placements = 
# 	bottom-end: css b:0 r:0
# 	bottom-start: css b:0 l:0
# 	top-end: css t:0 r:0
# 	top-start: css r:0 l:0


tag dropdown
	prop auto-close\boolean = true
	prop placement\"bottom-end"|"bottom-start"|"top-end"|"top-start" = "bottom-start"
	isShown?\boolean = false
	def show
		isShown? = true
	def hide
		isShown? = false
	def dropDownClick
		if auto-close
			hide!
		else
			show!
	get rectangle
		# depends on the placement prop: TODO implement other placements
		this.getBoundingClientRect!
	def render
		<self>
			<button[h:100%] type="button" @click=show>
				<slot />
				if isShown?
					<teleport to="#dropdown">
						<div>
							<div[pos:fixed t:0 r:0 l:0 b:0 z:99998 bg:black/20%] @click.stop=hide >
							<div[pos:relative zi:99999] @click.stop={dropDownClick}>
								const top = rectangle.bottom
								const left = rectangle.left
								<div[pos:absolute top:{top} left:{left}]
								 style="top: {top}; left: {left};"
								 >
									<slot name="dropdown">