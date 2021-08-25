import type { InputType } from '../'


tag text-input
	prop label\string
	prop error\string
	prop type\InputType
	prop autofocus\HTMLInputElement["autofocus"]
	prop autocapitalize\HTMLInputElement["autocapitalize"]
	<self>
		<div>
			if label
				<label .form-label for="id"> label
			<input .form-input .error=error id=(id or label) type=type bind=data />
			if error
				<div .form-error> error