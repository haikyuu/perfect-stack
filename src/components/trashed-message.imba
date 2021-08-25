tag trashed-message
	prop restore\VoidFunction
	def render
		<self[d:flex] .p-4.bg-yellow-300.rounded.flex.items-center.justify-between.max-w-3xl>
			<div .flex.items-center>
				<icon name="trash" .flex-shrink-0.w-4.h-4.fill-yellow-800.mr-2>
				<div .text-sm.font-medium.text-yellow-800>
					<slot>
			<button[c:yellow8] .text-sm.{'hover:underline'} tabindex="-1" type="button" @click=restore> "Restore"