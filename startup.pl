no warnings 'redefine';

# Modules with methods used in pages -- because of this, we change scope first
{
  package HTML::Mason::Commands;
  use Time::ParseDate;
  use Calendar::Simple;
  use Schedule;
}

1;
