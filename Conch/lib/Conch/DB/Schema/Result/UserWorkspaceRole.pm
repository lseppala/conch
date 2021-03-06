use utf8;
package Conch::DB::Schema::Result::UserWorkspaceRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Conch::DB::Schema::Result::UserWorkspaceRole

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::Helper::Row::ToJSON>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Helper::Row::ToJSON");

=head1 TABLE: C<user_workspace_role>

=cut

__PACKAGE__->table("user_workspace_role");

=head1 ACCESSORS

=head2 user_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 workspace_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "workspace_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<user_workspace_role_user_id_workspace_id_key>

=over 4

=item * L</user_id>

=item * L</workspace_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "user_workspace_role_user_id_workspace_id_key",
  ["user_id", "workspace_id"],
);

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Conch::DB::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Conch::DB::Schema::Result::Role",
  { id => "role_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<Conch::DB::Schema::Result::UserAccount>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Conch::DB::Schema::Result::UserAccount",
  { id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 workspace

Type: belongs_to

Related object: L<Conch::DB::Schema::Result::Workspace>

=cut

__PACKAGE__->belongs_to(
  "workspace",
  "Conch::DB::Schema::Result::Workspace",
  { id => "workspace_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2018-06-27 14:17:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IAXuJjWCQTi4rdUw+v+pQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 LICENSING

Copyright Joyent, Inc.

This Source Code Form is subject to the terms of the Mozilla Public License, 
v.2.0. If a copy of the MPL was not distributed with this file, You can obtain
one at http://mozilla.org/MPL/2.0/.

=cut

