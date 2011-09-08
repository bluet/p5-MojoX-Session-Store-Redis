package MojoX::Session::Store::Redis;

use warnings;
use strict;
use Redis;

use base 'MojoX::Session::Store';


use namespace::clean;

__PACKAGE__->attr('redis');
__PACKAGE__->attr('redis_prefix');
__PACKAGE__->attr('redis_dbid');


=encoding utf8
=head1 NAME

MojoX::Session::Store::Redis - RedisDB Store for MojoX::Session

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';


sub new {
	my ($class, $param) = @_;
	my $self = $class->SUPER::new();
	bless $self, $class;

	$param ||= {};
	my $dbid = $self->redis_dbid = delete $param->{redis_dbid};
	$self->redis_prefix(delete $param->{redis_prefix} || 'mojo-session');
	$param->{server} ||= '127.0.0.1:6379';
	
	$self->redis($param->{redis} || Redis->new($param));
	
	# FIXME: $dbid

	return $self;
}


sub create {
	my ($self, $sid, $expires, $data) = @_;
	my $prefix = $self->redis_prefix;

	$self->redis->set("$prefix:$sid:sid" => $sid);
	$self->redis->set("$prefix:$sid:data" => $data);
	$self->redis->set("$prefix:$sid:expires" => $expires);
	
	# FIXME
	# Check error
		#~ require Data::Dumper;
		#~ warn Data::Dumper::Dumper($err);
	
	1;
}


sub update {
	shift->create(@_);
}


sub load {
	my ($self, $sid) = @_;
	my $prefix = $self->redis_prefix;
	
	my $data = $self->redis->get("$prefix:$sid:data" => $data);
	my $expires = $self->redis->get("$prefix:$sid:expires" => $expires);
	
	return ($expires, $data);
}


sub delete {
	my ($self, $sid) = @_;
	my $prefix = $self->redis_prefix;
	$self->redis->del("$prefix:$sid:sid" => $sid);
	$self->redis->del("$prefix:$sid:data" => $data);
	$self->redis->del("$prefix:$sid:expires" => $expires);
	return 1;
}


=head1 SYNOPSIS

	my $session = MojoX::Session->new(
		tx        => $tx,
		store     => MojoX::Session::Store::Redis->new({
			server	=> '127.0.0.1:6379',
			redis_prefix	=> 'mojo-session',
			redis_dbid	=> 0,
		}),
		transport => MojoX::Session::Transport::Cookie->new,
	);

	# see doc for MojoX::Session


=head1 DESCRIPTION

L<MojoX::Session::Store::Redis> is a store for L<MojoX::Session> that stores a
session in a Redis database.


=head1 ATTRIBUTES

L<MojoX::Session::Store::Redis> implements the following attributes.

=head2 C<redis>
    
    my $db = $store->redis;

Get and set MojoX::Redis object.

=head2 C<redis_prefix>
    
    my $prefix = $store->redis_prefix;

Get and set the Key prefix of the stored session in Redis.
Default is 'mojo-session'.

=head2 C<redis_dbid>
    
    my $dbid = $store->redis_dbid;

Get and set the DB ID Number to use in Redis DB.
Default is 0.


=head1 METHODS

L<MojoX::Session::Store::Redis> inherits all methods from
L<MojoX::Session::Store>, and few more.

=head2 C<new>

C<new> uses the redis_prefix and redis_dbid parameters for the Key name prefix 
and the DB ID Number respectively. All other parameters are passed to C<MojoX::Redis->new()>.

=head2 C<create>

Insert session to Redis.

=head2 C<update>

Update session in Redis.

=head2 C<load>

Load session from Redis.

=head2 C<delete>

Delete session from Redis.


=head1 AUTHOR

BlueT - Matthew Lien - 練喆明, C<< <BlueT at BlueT.org> >>


=head1 BUGS

Please report any bugs or feature requests to C<bug-mojox-session-store-redis at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MojoX-Session-Store-Redis>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.



=head1 CONTRIBUTE

Main:

	bzr repository etc at L<https://launchpad.net/p5-mojox-session-store-redis>.

A copy of the codes:

	git repository etc at L<https://github.com/BlueT/p5-MojoX-Session-Store-Redis>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc MojoX::Session::Store::Redis


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MojoX-Session-Store-Redis>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MojoX-Session-Store-Redis>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MojoX-Session-Store-Redis>

=item * Search CPAN

L<http://search.cpan.org/dist/MojoX-Session-Store-Redis/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 BlueT - Matthew Lien - 練喆明.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of MojoX::Session::Store::Redis
