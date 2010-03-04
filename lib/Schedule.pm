package Schedule;

use Class::DBI;
use Schedule::Handle;
use Schedule::Loader;

my $loader = Schedule::Loader->new(
                                   dsn => "dbi:mysql:scheduling",
                                   namespace => "Schedule",
                                   user => "scheduling",
                                  ) or die "Can't connect to scheduling db";

Schedule::Times->has_a(userid => "Schedule::Users");
Schedule::Times->columns(Primary => qw/id/);
Schedule::Dates->has_a(userid => "Schedule::Users");
Schedule::Dates->columns(Primary => qw/id/);

Schedule::UserGames->has_a(userid => "Schedule::Users");
Schedule::UserGames->has_a(gameid => "Schedule::Games");

Schedule::Users->has_many(times => "Schedule::Times", "userid");
Schedule::Users->has_many(dates => "Schedule::Dates", "userid");
Schedule::Users->has_many(games => [ "Schedule::UserGames" => 'game']);

Schedule::Games->has_many(users => [ "Schedule::UserGames" => 'user']);

package Schedule::Games;
use Calendar::Simple;

sub Schedule::Games::named {
    my $class = shift;

    my $it = $class->search(name => shift);
    return $it->next;
}

sub Schedule::Games::required_users {
    my $self = shift;
    return map $_->user, Schedule::UserGames->search(gameid => $self->id, required => 1);
}

sub Schedule::Games::times {
    my $self = shift;

    # Find all users and the required users
    my @users = $self->users;
    my @required = $self->required_users;

    # Dig out when people are free
    my @times;
    for (Schedule::Times->search_where(available => 1, userid => [ map {$_->id} @users ])) {
        $times[$_->hour][$_->weekday]{Available}{$_->user->email} = 1;
    }

    # Compute which times work
    for my $hour (11 .. 26) {
        for my $day (0..6) {
            my %available = %{$times[$hour][$day]{Available}};

            my @present = grep {$available{$_->email}} @users;
            my @missing = grep {not $available{$_->email}} @required;

            my $missing = join ", ", sort map {$_->email} grep {not $available{$_->email}} @users;
            my $present = join ", ", sort map {$_->email} @present;

            if (not $missing) {
                $times[$hour][$day]{Message} = "Everyone free";
            } elsif (defined $self->minpresent) {
                $times[$hour][$day]{Message} = $present;
            } else {
                $times[$hour][$day]{Message} = "Missing $missing";
            }

            $times[$hour][$day]{Possible}   = not @missing;
            $times[$hour][$day]{Possible} &&= (@present >= $self->minpresent) if defined $self->minpresent;
            $times[$hour][$day]{Possible} &&= (@users - @present <= $self->maxmissing) if defined $self->maxmissing;
            $times[$hour][$day]{Impossible} = scalar @missing;
            $times[$hour][$day]{Available}  = scalar @present;
        }
    }
    return @times;
}

sub Schedule::Games::dates {
    my $self = shift;

    # Make the calendar for that time
    my $time = shift;
    my $mon  = (localtime($time))[4] + 1;
    my $year = (localtime($time))[5] + 1900;
    my @cal = calendar($mon, $year);

    # Find all users and the required users
    my @users = $self->users;
    my @required = $self->required_users;

    # Find when people are busy
    my %dates;
    for (Schedule::Dates->search_where(userid => [ map {$_->id} $self->users ])) {
        $dates{$_->day}{Available}{$_->user->email} = $_->available;
    }

    # For each day, do the math
    for my $r (@cal) {
        for my $d (@{$r}) {
            if ($d) {
                my $s = sprintf("%4d-%02d-%02d", $year, $mon, $d);
                my %available = %{$dates{$s}{Available}};

                my @present = grep {not exists $available{$_->email} or $available{$_->email}} @users;
                my @missing = grep {exists $available{$_->email} and not $available{$_->email}} @required;
                my $missing = join ", ", sort map {$_->email} grep {exists $available{$_->email} and not $available{$_->email}} @users;
                my $present = join ", ", sort map {$_->email} @present;

                my $possible = not @missing;
                $possible &&= (@users - @present <= $self->maxmissing) if defined $self->maxmissing;
                $possible &&= (@present >= $self->minpresent) if defined $self->minpresent;

                my $message;
                if (not $missing) {
                    $message = "Everyone free";
                } elsif (defined $self->minpresent) {
                    $message = $present;
                } else {
                    $message = "Missing $missing";
                }

                $d = {Message   => $message,
                      Possible  => $possible,
                      Impossible => scalar @missing,
                      Available => scalar @present,
                     };
            }
        }
    }
    return @cal;
}

sub Schedule::Games::update_from_blanche {
    warn "Updating games from blanche";
    my @games = Schedule::Games->search_where(blanche => { '!=', undef });
    for my $game (@games) {
        my $list = $game->blanche;
        my @blanche = `/usr/local/bin/blanche -noauth -u -r $list`;
        warn "Updating list $list";

        for my $krb (@blanche) {
            warn "Found krb $krb";
            chomp $krb;
            my $u = Schedule::Users->find_or_create({email => $krb});
            my $ug = Schedule::UserGames->find_or_create({userid => $u->id, gameid => $game->id});
            warn "Created $ug -- ".$u->email." in ".$game->name." ($list)";
        }
    }
}

1;

