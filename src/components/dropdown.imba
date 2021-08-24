# const placements = 
# 	bottom-end: css b:0 r:0
# 	bottom-start: css b:0 l:0
# 	top-end: css t:0 r:0
# 	top-start: css r:0 l:0


tag dropdown
	prop auto-close\boolean = true
	prop placement\"bottom-end"|"bottom-start"|"top-end"|"top-start"
	isShown?\boolean = false
	_placement
	# def setup
	# 	_placement = placements[placement]
	def show
		isShown? = true
	def hide
		isShown? = false
	def dropDownClick
		if auto-close
			hide!
		else
			show!
	def relayout
		const target = querySelector("#dropdown")

	def render
		<self>
			<button[h:100%] type="button" @click=show>
				<slot />
				if isShown?
					<teleport to="#dropdown">
						<div>
							<div[pos:fixed t:0 r:0 l:0 b:0 z:99998 bg:black/20%] @click.stop=hide >
							<div[pos:absolute zi:99999] @click.stop={dropDownClick}>
								<slot name="dropdown">