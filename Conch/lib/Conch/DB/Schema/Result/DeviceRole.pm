use utf8;
package Conch::DB::Schema::Result::DeviceRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Conch::DB::Schema::Result::DeviceRole

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

=head1 TABLE: C<device_role>

=cut

__PACKAGE__->table("device_role");

=head1 ACCESSORS

=head2 id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  size: 16

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 hardware_product_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

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

=head2 deactivated

  data_type: 'timestamp with time zone'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    size => 16,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "hardware_product_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
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
  "deactivated",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 device_role_services

Type: has_many

Related object: L<Conch::DB::Schema::Result::DeviceRoleService>

=cut

__PACKAGE__->has_many(
  "device_role_services",
  "Conch::DB::Schema::Result::DeviceRoleService",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 devices

Type: has_many

Related object: L<Conch::DB::Schema::Result::Device>

=cut

__PACKAGE__->has_many(
  "devices",
  "Conch::DB::Schema::Result::Device",
  { "foreign.role" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 hardware_product

Type: belongs_to

Related object: L<Conch::DB::Schema::Result::HardwareProduct>

=cut

__PACKAGE__->belongs_to(
  "hardware_product",
  "Conch::DB::Schema::Result::HardwareProduct",
  { id => "hardware_product_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2018-06-27 14:17:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7tQgkL+mBtGJXoO64jFRIA


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

