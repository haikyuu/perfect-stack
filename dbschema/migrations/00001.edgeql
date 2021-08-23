CREATE MIGRATION m17jaf4mffrjkk7fghcad6oxsrmmuqetc6zmoi4cexp2b4vfn77o7q
    ONTO initial
{
  CREATE TYPE default::User {
      CREATE REQUIRED PROPERTY created_at -> cal::local_datetime {
          SET default := (cal::to_local_datetime(std::datetime_current(), 'UTC'));
      };
      CREATE PROPERTY deleted_at -> std::datetime;
      CREATE REQUIRED PROPERTY email -> std::str {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE PROPERTY email_verified_at -> cal::local_datetime;
      CREATE REQUIRED PROPERTY first_name -> std::str;
      CREATE REQUIRED PROPERTY last_name -> std::str;
      CREATE REQUIRED PROPERTY owner -> std::bool {
          SET default := false;
      };
      CREATE PROPERTY password -> std::str;
      CREATE PROPERTY photo_path -> std::str;
      CREATE PROPERTY remember_token -> std::str;
  };
};
