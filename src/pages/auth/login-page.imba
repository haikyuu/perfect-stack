import Form from '../../inertia/Form'

tag login-page
	def setup
		self.form = new Form
			email: 'mail@mail.com'
			password: 'password'
			remember: true

	def render
		<self>
			<div .p-6.bg-indigo-800.min-h-screen.flex.justify-center.items-center>
				<div .w-full.max-w-md>
					<logo .block.mx-auto.w-full.max-w-xs.fill-white [h:50px] />
					<form .mt-8.bg-white.rounded-lg.shadow-xl.overflow-hidden @submit.prevent=form.submit("post", "/login")>
						<div .px-10.py-12>
							<h1 .text-center.font-bold.text-3xl> "Welcome Back!"
							<div .mx-auto.mt-6.w-24.border-b-2 />
							<text-input bind=form.data.email error=form.errors.email label="Email" type="email" autofocus autocapitalize="off" .mt-10 />
							<text-input bind=form.data.password error=form.errors.password .mt-6 label="Password" type="password" />
							<label .mt-6.select-none.flex.items-center for="remember">
								<input id="remember" bind=form.data.remember .mr-1 type="checkbox" />
								<span .text-sm> "Remember Me"
							
						
						<div .px-10.py-4.bg-gray-100.border-t.border-gray-100.flex>
							<loading-button loading=form.processing .ml-auto.btn-indigo type="submit"> "Login"
			
		
	