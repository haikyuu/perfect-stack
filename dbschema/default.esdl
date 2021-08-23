module default {
	# by default, all dates are in UTC
	type User {
		required property first_name -> str;
		required property last_name -> str;
		required property email -> str {
			constraint exclusive;
		}
		property email_verified_at -> cal::local_datetime;
		property password -> str;
		required property owner -> bool {
			default := False;
		}
		property photo_path -> str;
		required property created_at -> cal::local_datetime {
			default := cal::to_local_datetime(datetime_current(), 'UTC');
		}
		property deleted_at -> datetime;
		property remember_token -> str;
		# see https://laravel.com/docs/4.2/upgrade#upgrade-4.1.29
	}
}
