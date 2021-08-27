CREATE MIGRATION m1oz2tq5hxskt4csdyqjxjs76txp2jenpurijmge2kh67eqbkb56xq
    ONTO m1xunomwswwrf7iskdxsekf4uft6jpeapuzhkplajty4qdjq5uk2fq
{
  ALTER TYPE default::User {
      CREATE PROPERTY name := ((((.first_name ++ ' ') ++ .last_name) IF EXISTS (.last_name) ELSE .first_name));
  };
};
