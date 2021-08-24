CREATE MIGRATION m17n33vyk6esc7ay4i2h76rw42llkuewlemjnlfbn75cf5hiklmnga
    ONTO m17jaf4mffrjkk7fghcad6oxsrmmuqetc6zmoi4cexp2b4vfn77o7q
{
  CREATE ABSTRACT TYPE default::WithSoftDeletes {
      CREATE PROPERTY deleted_at -> std::datetime;
  };
  CREATE ABSTRACT TYPE default::WithTimestamps {
      CREATE REQUIRED PROPERTY created_at -> cal::local_datetime {
          SET default := (cal::to_local_datetime(std::datetime_current(), 'UTC'));
      };
  };
  ALTER TYPE default::User {
      EXTENDING default::WithTimestamps,
      default::WithSoftDeletes LAST;
      ALTER PROPERTY created_at {
          DROP OWNED;
          RESET OPTIONALITY;
          RESET TYPE;
      };
      ALTER PROPERTY deleted_at {
          DROP OWNED;
          RESET TYPE;
      };
  };
  CREATE TYPE default::Organization EXTENDING default::WithTimestamps, default::WithSoftDeletes {
      CREATE REQUIRED LINK account -> default::User;
      CREATE PROPERTY address -> std::str;
      CREATE PROPERTY city -> std::str;
      CREATE PROPERTY country -> std::str;
      CREATE PROPERTY email -> std::str;
      CREATE REQUIRED PROPERTY name -> std::str;
      CREATE PROPERTY phone -> std::str;
      CREATE PROPERTY postal_code -> std::str;
      CREATE PROPERTY region -> std::str;
  };
};
