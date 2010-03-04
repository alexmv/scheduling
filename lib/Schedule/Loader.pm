package Schedule::Loader;
use base qw(Class::DBI::Loader::mysql);

sub _db_class {
  return "Schedule::Handle";
}

1;
