module default {
	abstract type WithTimestamps{
		required property created_at -> cal::local_datetime {
			default := cal::to_local_datetime(datetime_current(), 'UTC');
		}
	}
	abstract type WithSoftDeletes {
		property deleted_at -> datetime;
	}
	# by default, all dates are in UTC
	type User extending WithTimestamps, WithSoftDeletes {
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
		property remember_token -> str;
		# see https://laravel.com/docs/4.2/upgrade#upgrade-4.1.29
	}

	type Organization extending WithTimestamps, WithSoftDeletes {
		required link account -> User;
		required property name -> str;
		property email -> str;
		property phone -> str;
		property address -> str;
		property city -> str;
		property region -> str;
		property country -> str;
		property postal_code -> str;
	}
}
