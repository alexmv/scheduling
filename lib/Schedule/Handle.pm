package Schedule::Handle;

use base qw(Class::DBI::mysql);
use Class::DBI::AbstractSearch;
use Carp;

# Accessors should strip trailing "Id" from column names
sub accessor_name_for {
    my ($class, $column) = @_;
    $column =~ s/Id$//i;
    return $column;
}

# Override the "essential" columns to be all of them
sub _essential {
    my $self = shift;
    return $self->all_columns;
}

sub _auto_increment_value {
    my $self = shift;
    my $dbh = $self->db_Main;

    my ($id) = $dbh->selectrow_array("SELECT LAST_INSERT_ID()");

    Carp::croak("Can't get insert id") unless $id;
    
    return $id;
}

1;
