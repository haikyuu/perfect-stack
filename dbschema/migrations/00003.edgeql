CREATE MIGRATION m1iepbg6q65oubedirjc226akcu57tspdn23x6pdlxclraac6knila
    ONTO m17n33vyk6esc7ay4i2h76rw42llkuewlemjnlfbn75cf5hiklmnga
{
  ALTER TYPE default::Organization {
      ALTER PROPERTY name {
          CREATE CONSTRAINT std::min_len_value(3);
      };
  };
};
