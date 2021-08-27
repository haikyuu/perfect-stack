tag file-input
	prop label\string
	prop error\string
	prop accept\string
	prop value\Object
	prop onChange\VoidFunction

	get fileSize
		const size = value..size
		if !size
			return ""
		const i = Math.floor(Math.log(size) / Math.log(1024))
		"{(size / Math.pow(1024, i)).toFixed(2)} {['B', 'kB', 'MB', 'GB', 'TB'][i]}"
	get fileName
		console.log value
		value..name
	def render
		<self>
			if label
				<label .form-label> label
			<div .form-input.p-0 .error=error>
				<input$file type="file" accept=accept .hidden @change=(do() onChange $file.files[0]) />
				if !value
					<div.p-2>
						<button type="button" .px-4.py-1.bg-gray-500.{'hover:bg-gray-700'}.rounded-sm.text-xs.font-medium.text-white @click=$file.click>
							"Browse"
				else
					<div.flex.items-center.justify-between.p-2>
						<div .flex-1.pr-1>
							fileName
							<span[ml:2] .text-gray-500.text-xs> fileSize
						
						<button type="button" .px-4.py-1.bg-gray-500.{'hover:bg-gray-700'}.rounded-sm.text-xs.font-medium.text-white @click=($file.value = null)>
							"Remove"
				if error
					<div .form-error> error