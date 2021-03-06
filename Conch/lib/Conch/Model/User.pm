=pod

=head1 NAME

Conch::Model::User

=head1 METHODS

=cut
package Conch::Model::User;
use Mojo::Base -base, -signatures;

use Crypt::Eksblowfish::Bcrypt qw(bcrypt en_base64);
use Conch::UUID qw(is_uuid);
use Mojo::JSON 'to_json';

has [
	qw(
		email
		id
		name
		password_hash
		)
];

sub _BCRYPT_COST { 4 }    # dancer2 legacy

=head2 create

Create a new user

=cut
sub create ( $class, $email, $password ) {
	my $password_hash = _hash_password($password);

	my $ret =
		Conch::Pg->new->db->select( 'user_account', ['id'], { email => $email }, )->rows;
	return undef if $ret;

	$ret = Conch::Pg->new->db->insert(
		'user_account',
		{
			email         => $email,
			password_hash => $password_hash,
			name          => $email
		},
		{ returning => [qw(id)], }
	)->hash;

	return undef unless ( $ret && $ret->{id} );
	return $class->new(
		id            => $ret->{id},
		email         => $email,
		name          => $email,
		password_hash => $password_hash,
	);
}

=head2 lookup

Look up user by ID if $id is UUID, then try to lookup by name, and finally try
by email. Otherwise, return undef.

=cut
sub lookup ( $class, $id ) {
	my $where = {};
	my $ret;
	if ( is_uuid($id) ) {
		$ret = Conch::Pg->new->db->select( 'user_account', undef, { id => $id }, )->hash;
	}
	else {
		$ret = Conch::Pg->new->db->select( 'user_account', undef, { name => $id }, )->hash;

		unless ($ret) {
			$ret = Conch::Pg->new->db->select( 'user_account', undef, { email => $id }, )->hash;
		}
	}

	return undef unless $ret;

	$ret->{password_hash} =~ s/^{CRYPT}//;    # ohai dancer
	return $class->new(
		id            => $ret->{id},
		email         => $ret->{email},
		name          => $ret->{name},
		password_hash => $ret->{password_hash},
	);
}

=head2 lookup_by_email
=cut
sub lookup_by_email ( $class, $email ) {
	return $class->lookup( $email );
}

=head2 lookup_by_name
=cut
sub lookup_by_name ( $class, $name ) {
	return $class->lookup( $name );
}

=head2 update_password

Update user's password. Stores a bcrypt'd hashed password.

=cut
sub update_password ( $self, $p ) {
	my $password_hash = _hash_password($p);
	my $ret           = Conch::Pg->new->db->update(
		'user_account',
		{ password_hash => $password_hash },
		{ id            => $self->id }
	);
	if ( scalar $ret->rows ) {
		$self->password_hash($password_hash);
		return 1;
	}
	return 0;
}

=head2 validate_password

Check whether the given password text has a hash matching the stored password hash.

=cut
sub validate_password ( $self, $p ) {
	return Mojo::Util::secure_compare( $self->password_hash,
		bcrypt( $p, $self->password_hash ) );
}

=head2 settings

Retrieve all user's stored settings.

=cut
sub settings ($self) {
	my $ret = Conch::Pg->new->db->select(
		'user_settings',
		undef,
		{
			deactivated => undef,
			user_id     => $self->id,
		}
	)->expand->hashes;

	my %settings;
	for my $setting ( $ret->@* ) {
		$settings{ $setting->{name} } = $setting->{value};
	}
	return \%settings;
}

=head2 set_setting

Set and store a single setting.

=cut
sub set_setting ( $self, $key, $value ) {
	Conch::Pg->new->db->update(
		'user_settings',
		{ deactivated => 'now()' },
		{
			user_id     => $self->id,
			name        => $key,
			deactivated => undef
		}
	);

	my $ret = Conch::Pg->new->db->insert(
		'user_settings',
		{
			user_id => $self->id,
			name    => $key,
			value   => to_json($value)
		}
	);

	return $ret->rows;
}

=head2 setting

Retrieve a single setting specified by a key.

=cut
sub setting ( $self, $key ) {
	return $self->settings()->{$key};
}

=head2 delete_setting

Delete (deactivate) a specified setting.

=cut
sub delete_setting ( $self, $key ) {
	my $ret = Conch::Pg->new->db->update(
		'user_settings',
		{ deactivated => 'now()' },
		{
			user_id     => $self->id,
			name        => $key,
			deactivated => undef
		}
	);

	return $ret->rows;
}

=head2 set_settings

Set and store a collection of settings.

=cut
sub set_settings ( $self, $settings ) {
	my $current_settings = $self->settings;
	for my $setting ( keys $current_settings->%* ) {
		$self->delete_setting($setting);
	}

	for my $setting ( keys $settings->%* ) {
		$self->set_setting( $setting, $settings->{$setting} );
	}

	return $self->settings;
}

###########

sub _hash_password ($p) {
	my $cost = sprintf( '%02d', _BCRYPT_COST || 6 );
	my $settings = join( '$', '$2a', $cost, _bcrypt_salt() );
	return bcrypt( $p, $settings );
}

sub _bcrypt_salt {
	my $num = 999999;
	my $cr = crypt( rand($num), rand($num) ) . crypt( rand($num), rand($num) );
	en_base64( substr( $cr, 4, 16 ) );
}

1;


__DATA__

=pod

=head1 LICENSING

Copyright Joyent, Inc.

This Source Code Form is subject to the terms of the Mozilla Public License, 
v.2.0. If a copy of the MPL was not distributed with this file, You can obtain
one at http://mozilla.org/MPL/2.0/.

=cut

