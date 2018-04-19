=head1 NAME

Conch::Route::Orc

=head1 DESCRIPTION

Mojo routes for Conch's orchestration system

=head1 SYNOPSIS

Conch::Route::Orc->load( $r );

=head1 METHODS

=cut

package Conch::Route::Orc;

use Mojo::Base -base, -signatures;


=head2 load

Load up all the routes and attendant subsystems

=cut

use Conch::Orc;
use Conch::Controller::Orc::Workflows;
use Conch::Controller::Orc::WorkflowSteps;
use Conch::Controller::Orc::Lifecycles;

sub load ( $class, $r ) {
	my $o = $r->under("/o")->under(sub {
		my $c = shift;

		return 1 if $c->is_global_admin;

		$c->status(403);
		return undef;
	});

	my $l = $o->under("/lifecycle");
	$l->post("/")->to("Orc::Lifecycles#create");
	$l->get("/")->to("Orc::Lifecycles#get_all");
	$l->get("/:id")->to("Orc::Lifecycles#get_one");
	$l->post("/:id/add_workflow")->to("Orc::Lifecycles#add_workflow");
	$l->post("/:id/remove_workflow")->to("Orc::Lifecycles#remove_workflow");

	my $w = $o->under("/workflow");
	$w->post("/")->to("Orc::Workflows#create");
	$w->get("/")->to("Orc::Workflows#get_all");
	$w->get("/:id")->to("Orc::Workflows#get_one");

	my $wi = $w->under("/:id");
	$wi->post("/")->to("Orc::Workflows#update");
	$wi->post("/step")->to("Orc::Workflows#create_step");

	my $si = $o->under("/step/:id");
	$si->post("/")->to("Orc::WorkflowSteps#update");
	$si->delete("/")->to("Orc::WorkflowSteps#delete");

	$o->get("/step/:id")->to("Orc::WorkflowSteps#get_one");
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

