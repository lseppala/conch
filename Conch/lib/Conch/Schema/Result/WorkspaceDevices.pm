package Conch::Schema::Result::WorkspaceDevices;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;
use Conch::Schema::Result::Device;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

# For the time being this is necessary even for virtual views
__PACKAGE__->table('WorkspaceDevices');

#
# Has the same columns as 'Device'
__PACKAGE__->add_columns(Conch::Schema::Result::Device->columns);

# do not attempt to deploy() this view
__PACKAGE__->result_source_instance->is_virtual(1);

# NOTE! This will break if any of the relations between 'user_account' and 'device' change!
# Takes a username and returns the list of devices the user has access to
__PACKAGE__->result_source_instance->view_definition(q[
  SELECT device.*
  FROM workspace_datacenter_room wdr
  JOIN datacenter_rack rack
    ON wdr.datacenter_room_id = rack.datacenter_room_id
  JOIN device_location loc
    ON rack.id = loc.rack_id
  JOIN device
    ON loc.device_id = device.id
  WHERE wdr.workspace_id = ?
    AND device.deactivated is null
]);

# NOTE: UPDATE BELOW WHEN Conch::Result::Device IS UPDATED!
=head1 RELATIONS

=head2 device_disks

Type: has_many

Related object: L<Conch::Schema::Result::DeviceDisk>

=cut

__PACKAGE__->has_many(
  "device_disks",
  "Conch::Schema::Result::DeviceDisk",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_environment

Type: might_have

Related object: L<Conch::Schema::Result::DeviceEnvironment>

=cut

__PACKAGE__->might_have(
  "device_environment",
  "Conch::Schema::Result::DeviceEnvironment",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_location

Type: might_have

Related object: L<Conch::Schema::Result::DeviceLocation>

=cut

__PACKAGE__->might_have(
  "device_location",
  "Conch::Schema::Result::DeviceLocation",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_logs

Type: has_many

Related object: L<Conch::Schema::Result::DeviceLog>

=cut

__PACKAGE__->has_many(
  "device_logs",
  "Conch::Schema::Result::DeviceLog",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_memories

Type: has_many

Related object: L<Conch::Schema::Result::DeviceMemory>

=cut

__PACKAGE__->has_many(
  "device_memories",
  "Conch::Schema::Result::DeviceMemory",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_nics

Type: has_many

Related object: L<Conch::Schema::Result::DeviceNic>

=cut

__PACKAGE__->has_many(
  "device_nics",
  "Conch::Schema::Result::DeviceNic",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_notes

Type: has_many

Related object: L<Conch::Schema::Result::DeviceNote>

=cut

__PACKAGE__->has_many(
  "device_notes",
  "Conch::Schema::Result::DeviceNote",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_relay_connections

Type: has_many

Related object: L<Conch::Schema::Result::DeviceRelayConnection>

=cut

__PACKAGE__->has_many(
  "device_relay_connections",
  "Conch::Schema::Result::DeviceRelayConnection",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_reports

Type: has_many

Related object: L<Conch::Schema::Result::DeviceReport>

=cut

__PACKAGE__->has_many(
  "device_reports",
  "Conch::Schema::Result::DeviceReport",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_settings

Type: has_many

Related object: L<Conch::Schema::Result::DeviceSetting>

=cut

__PACKAGE__->has_many(
  "device_settings",
  "Conch::Schema::Result::DeviceSetting",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_spec

Type: might_have

Related object: L<Conch::Schema::Result::DeviceSpec>

=cut

__PACKAGE__->might_have(
  "device_spec",
  "Conch::Schema::Result::DeviceSpec",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 device_validates

Type: has_many

Related object: L<Conch::Schema::Result::DeviceValidate>

=cut

__PACKAGE__->has_many(
  "device_validates",
  "Conch::Schema::Result::DeviceValidate",
  { "foreign.device_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 hardware_product

Type: belongs_to

Related object: L<Conch::Schema::Result::HardwareProduct>

=cut

__PACKAGE__->belongs_to(
  "hardware_product",
  "Conch::Schema::Result::HardwareProduct",
  { id => "hardware_product" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 triton

Type: might_have

Related object: L<Conch::Schema::Result::Triton>

=cut

__PACKAGE__->might_have(
  "triton",
  "Conch::Schema::Result::Triton",
  { "foreign.id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);