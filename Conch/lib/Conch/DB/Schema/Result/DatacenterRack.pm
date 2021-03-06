use utf8;
package Conch::DB::Schema::Result::DatacenterRack;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Conch::DB::Schema::Result::DatacenterRack

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

=head1 TABLE: C<datacenter_rack>

=cut

__PACKAGE__->table("datacenter_rack");

=head1 ACCESSORS

=head2 id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  size: 16

=head2 datacenter_room_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 role

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 deactivated

  data_type: 'timestamp with time zone'
  is_nullable: 1

=head2 created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 updated

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    size => 16,
  },
  "datacenter_room_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "role",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "deactivated",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "created",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 datacenter_rack_layouts

Type: has_many

Related object: L<Conch::DB::Schema::Result::DatacenterRackLayout>

=cut

__PACKAGE__->has_many(
  "datacenter_rack_layouts",
  "Conch::DB::Schema::Result::DatacenterRackLayout",
  { "foreign.rack_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 datacenter_room

Type: belongs_to

Related object: L<Conch::DB::Schema::Result::DatacenterRoom>

=cut

__PACKAGE__->belongs_to(
  "datacenter_room",
  "Conch::DB::Schema::Result::DatacenterRoom",
  { id => "datacenter_room_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 device_locations

Type: has_many

Related object: L<Conch::DB::Schema::Result::DeviceLocation>

=cut

__PACKAGE__->has_many(
  "device_locations",
  "Conch::DB::Schema::Result::DeviceLocation",
  { "foreign.rack_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role

Type: belongs_to

Related object: L<Conch::DB::Schema::Result::DatacenterRackRole>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Conch::DB::Schema::Result::DatacenterRackRole",
  { id => "role" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 workspace_datacenter_racks

Type: has_many

Related object: L<Conch::DB::Schema::Result::WorkspaceDatacenterRack>

=cut

__PACKAGE__->has_many(
  "workspace_datacenter_racks",
  "Conch::DB::Schema::Result::WorkspaceDatacenterRack",
  { "foreign.datacenter_rack_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2018-06-27 14:17:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vvwoxHCGwFaV4VaT9fNBfg


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

