tag page-layout
	def render
		const user = #context.currentPage.page.props.auth.user
		<self>
			<div[zi:20] id="dropdown">
			<div .{'md:flex'}.{'md:flex-col'}>
				<div .{'md:h-screen'}.{'md:flex'}.{'md:flex-col'}>
					<div .{'md:flex'}.{'md:flex-shrink-0'}>
						<div .bg-indigo-900.{'md:flex-shrink-0'}.{'md:w-56'}.px-6.py-4.flex.items-center.justify-between.{'md:justify-center'}>
							<inertia-link .mt-1 href="/">
								<logo .fill-white width="120" height="28" />
							
							<dropdown .{'md:hidden'} placement="bottom-end">
								<svg .fill-white.w-6.h-6 xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
									<path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z" />
								
								<div slot="dropdown" .px-8.py-4.shadow-lg.bg-indigo-800.rounded>
									<main-menu />
								
							
						
						<div .bg-white.border-b.w-full.p-4.{'md:py-0'}.{'md:px-12'}.text-sm.{'md:text-md'}.flex.justify-between.items-center>
							<div .mt-1.mr-4>  user.first_name
							<dropdown .mt-1 placement="bottom-end">
								<div .flex.items-center.cursor-pointer.select-none.group>
									<div .text-gray-700.{'group-hover:text-indigo-600'}.{'focus:text-indigo-600'}.mr-1.whitespace-nowrap>
										<span> user.first_name
										<span[ml:1] .hidden.{'md:inline'}> user.last_name
									
									<icon .w-5.h-5.{'group-hover:fill-indigo-600'}.fill-gray-700.{'focus:fill-indigo-600'} name="cheveron-down" />
								
								<div slot="dropdown" .py-2.shadow-xl.bg-white.rounded.text-sm>
									<inertia-link[ta:start] .block.px-6.py-2.{'hover:bg-indigo-500'}.{'hover:text-white'} href="/users/{user.id}/edit"> "My Profile"
									<inertia-link .block.px-6.py-2.{'hover:bg-indigo-500'}.{'hover:text-white'} href="/users"> "Manage Users"
									<inertia-button-link .block.px-6.py-2.{'hover:bg-indigo-500'}.{'hover:text-white'}.w-full.text-left href="/login" method="delete"> "Logout"
								
							
						
					
					<div .{'md:flex'}.{'md:flex-grow'}.{'md:overflow-hidden'}>
						<main-menu .hidden.{'md:block'}.bg-indigo-800.flex-shrink-0.w-56.p-12.overflow-y-auto />
						<div .{'md:flex-1'}.px-4.py-8.{'md:p-12'}.{'md:overflow-y-auto'} scroll-region>
							<div[w:100% h:1] innerHTML="<div style='width:100%; height:1px' scroll-region/>">
							<flash-messages>
							<slot />
						
					
				
			