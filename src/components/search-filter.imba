tag search-filter
	prop reset\VoidFunction
	prop maxWidth\string = 300px
	prop _change\VoidFunction
	prop value\string
	prop filter\string
	def render
		<self .flex.items-center>
			<div .flex.w-full.bg-white.shadow.rounded>
				<dropdown auto-close=no .px-4.{'md:px-6'}.rounded-l.border-r.{'hover:bg-gray-100'}.{'focus:border-white'}.{'focus:ring'}.{'focus:z-10'} placement="bottom-start">
					<div[w:115px] .flex.items-baseline>
						<span .text-gray-700.hidden.{'md:inline'}>	filter or "Filter"
						<svg .w-2.h-2.fill-gray-700.{'md:ml-2'} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 961.243 599.998">
							<path d="M239.998 239.999L0 0h961.243L721.246 240c-131.999 132-240.28 240-240.624 239.999-.345-.001-108.625-108.001-240.624-240z" >
						
					
					<div [max-width:{maxWidth}] slot="dropdown" .mt-2.px-4.py-6.w-screen.shadow-xl.bg-white.rounded>
						<slot>
					
				
				<input[z:10] .relative.w-full.px-6.py-3.rounded-r.{'focus:ring'} autocomplete="off" type="text" name="search" placeholder="Search…" bind=data @input.debounce(200ms)=_change />
			
			<button .ml-3.text-sm.text-gray-500.{'hover:text-gray-700'}.{'focus:text-indigo-500'} type="button" @click=reset> "Reset"