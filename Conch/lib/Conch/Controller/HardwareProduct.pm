=pod

=head1 NAME

Conch::Controller::HardwareProduct

=head1 METHODS

=cut

package Conch::Controller::HardwareProduct;

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Conch::UUID 'is_uuid';

use Conch::Models;

=head2 list

Get a list of all available hardware products, as serialized
Class::HardwareProduct objects

=cut

sub list ($c) {
	my $hardware_products = Conch::Model::HardwareProduct->new->list;
	$c->status( 200, $hardware_products );
}


=head2 get

Get the details of a single hardware product, given a valid UUID, as a
serialized Class::HardwareProduct object

=cut

sub get ($c) {
	my $hw_id = $c->param('id');
	return $c->status( 400,
		{ error => "Hardware Product ID must be a UUID. Got '$hw_id'." } )
		unless is_uuid($hw_id);
	my $hw_attempt = Conch::Model::HardwareProduct->new->lookup($hw_id);
	if ($hw_attempt) {
		return $c->status( 200, $hw_attempt );
	}
	else {
		return $c->status( 404, { error => "Hardware Product $hw_id not found" } );
	}
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

