CREATE MIGRATION m1ty4xwamqqhasln23rczlwrursrwkhhrspanryltu4adq6yzxvsbq
    ONTO m1iepbg6q65oubedirjc226akcu57tspdn23x6pdlxclraac6knila
{
  CREATE TYPE default::Contact EXTENDING default::WithTimestamps, default::WithSoftDeletes {
      CREATE REQUIRED LINK account -> default::User;
      CREATE LINK organization -> default::Organization;
      CREATE PROPERTY address -> std::str;
      CREATE PROPERTY city -> std::str;
      CREATE PROPERTY country -> std::str;
      CREATE PROPERTY email -> std::str;
      CREATE REQUIRED PROPERTY first_name -> std::str {
          CREATE CONSTRAINT std::min_len_value(3);
      };
      CREATE REQUIRED PROPERTY last_name -> std::str {
          CREATE CONSTRAINT std::min_len_value(3);
      };
      CREATE PROPERTY phone -> std::str;
      CREATE PROPERTY postal_code -> std::str;
      CREATE PROPERTY region -> std::str;
  };
};
