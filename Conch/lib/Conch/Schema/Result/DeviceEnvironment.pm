use utf8;
package Conch::Schema::Result::DeviceEnvironment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Conch::Schema::Result::DeviceEnvironment

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

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<device_environment>

=cut

__PACKAGE__->table("device_environment");

=head1 ACCESSORS

=head2 device_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 cpu0_temp

  data_type: 'integer'
  is_nullable: 1

=head2 cpu1_temp

  data_type: 'integer'
  is_nullable: 1

=head2 inlet_temp

  data_type: 'integer'
  is_nullable: 1

=head2 exhaust_temp

  data_type: 'integer'
  is_nullable: 1

=head2 psu0_voltage

  data_type: 'numeric'
  is_nullable: 1

=head2 psu1_voltage

  data_type: 'numeric'
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
  "device_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "cpu0_temp",
  { data_type => "integer", is_nullable => 1 },
  "cpu1_temp",
  { data_type => "integer", is_nullable => 1 },
  "inlet_temp",
  { data_type => "integer", is_nullable => 1 },
  "exhaust_temp",
  { data_type => "integer", is_nullable => 1 },
  "psu0_voltage",
  { data_type => "numeric", is_nullable => 1 },
  "psu1_voltage",
  { data_type => "numeric", is_nullable => 1 },
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

=item * L</device_id>

=back

=cut

__PACKAGE__->set_primary_key("device_id");

=head1 RELATIONS

=head2 device

Type: belongs_to

Related object: L<Conch::Schema::Result::Device>

=cut

__PACKAGE__->belongs_to(
  "device",
  "Conch::Schema::Result::Device",
  { id => "device_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-17 01:22:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XA81dfpUge1jVnmTy8yYMw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
