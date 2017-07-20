use utf8;
package Conch::Schema::Result::TritonPostSetupLog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Conch::Schema::Result::TritonPostSetupLog

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<triton_post_setup_log>

=cut

__PACKAGE__->table("triton_post_setup_log");

=head1 ACCESSORS

=head2 id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  size: 16

=head2 stage_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 log

  data_type: 'text'
  is_nullable: 0

=head2 created

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
  "stage_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "log",
  { data_type => "text", is_nullable => 0 },
  "created",
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

=head2 stage

Type: belongs_to

Related object: L<Conch::Schema::Result::TritonPostSetup>

=cut

__PACKAGE__->belongs_to(
  "stage",
  "Conch::Schema::Result::TritonPostSetup",
  { id => "stage_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2017-07-19 21:27:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Hnia5CDZS5g2JqojqZA9EA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
