INSERT User {
	email := 'mail@mail.com',
	password := '$2b$10$cCzbGHgpGM2bPV.FbDKr.uuG0ZnhXHWD8lNp3V1rIet3WsvQn5b3q',
	first_name := 'Abdellah',
	last_name := 'Alaoui'
} UNLESS conflict on .email;

INSERT Organization {
	name := 'Organization',
	account := (SELECT User Filter User.email = 'mail@mail.com'),
	phone := '+212 654 567 890',
	address := 'Address',
	city := 'City',
	country := 'Country',
	region := 'Region',
	postal_code := 'Postal Code'

}