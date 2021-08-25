tag pagination
	prop links\{url:string, label:string, active:boolean}[]
	def render
		<self[d:block]> 
			if links.length > 3
				<div .flex.flex-wrap.{'-mb-1'}>
					for link in links
						<div>
							if !link.url
								<div[d:inline] .mr-1.mb-1.px-4.py-3.text-sm.leading-4.text-gray-400.border.rounded innerHTML=link.label>
							else
								<inertia-link .mr-1.mb-1.px-4.py-3.text-sm.leading-4.border.rounded.{'hover:bg-white'}.{'focus:border-indigo-500'}.{'focus:text-indigo-500'}
								 .bg-white=link.active href=link.url innerHTML=link.label> 
			
		