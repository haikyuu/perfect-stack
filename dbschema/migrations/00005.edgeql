CREATE MIGRATION m1xunomwswwrf7iskdxsekf4uft6jpeapuzhkplajty4qdjq5uk2fq
    ONTO m1ty4xwamqqhasln23rczlwrursrwkhhrspanryltu4adq6yzxvsbq
{
  ALTER TYPE default::Contact {
      CREATE PROPERTY name := (((.first_name ++ ' ') ++ .last_name));
  };
};
