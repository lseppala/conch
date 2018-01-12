package Conch::Model::WorkspaceRoom;
use Mojo::Base -base, -signatures;

use Attempt qw(fail success);
use aliased 'Conch::Class::DatacenterRoom';

has 'pg';

sub list ($self, $ws_id) {
  $self->pg->db->query(
    q{
      SELECT dr.id, dr.az, dr.alias, dr.vendor_name
      FROM datacenter_room dr
      JOIN workspace_datacenter_room wdr
        ON dr.id = wdr.datacenter_room_id
      WHERE wdr.workspace_id = ?::uuid
    }, $ws_id
  )->hashes->map(sub { DatacenterRoom-new($_)})->to_array;
}

sub replace_workspace_rooms ($self, $ws_id, $room_ids) {
  my $db = $self->pg->db;
  my $parent_room_ids = $db->query(
    q{
      SELECT wdr.datacenter_room_id
      FROM workspace_datacenter_room wdr
      WHERE wdr.workspace_id = (
        SELECT ws.parent_workspace_id
        FROM workspace ws
        WHERE ws.id = ?::uuid
    )
    }, $ws_id
  )->hashes->map( sub { $_->{datacenter_room_id} } )->to_array;

  my @invalid_room_ids =
    List::Compare->new( $room_ids, $parent_room_ids )->get_unique;
  if ( scalar @invalid_room_ids ) {
    return fail(
      'Datacenter room IDs must be members of the parent workspace: '
        . join( ', ', @invalid_room_ids ) );
  }

  my $current_room_ids = $db->query(
    q{
      SELECT wdr.datacenter_room_id
      FROM workspace_datacenter_room wdr
      WHERE wdr.workspace_id = ?::uuid
    }, $ws_id
  )->hashes->map( sub { $_->{datacenter_room_id} } )->to_array;
  my @ids_to_remove =
    List::Compare->new( $current_room_ids, $room_ids )->get_unique;
  my @ids_to_add =
    List::Compare->new( $room_ids, $current_room_ids )->get_unique;

  my $tx  = $db->begin;
  my $sql = SQL::Abstract->new;

  # Remove room IDs from workspace and all children workspaces
  # Use SQL::Abstract to generate the WHERE IN clause
  if ( scalar @ids_to_remove ) {
    my ( $remove_where_clause, @remove_id_binds ) =
      $sql->where( { datacenter_room_id => { -in => \@ids_to_remove } } );
    $db->query(
      qq{
        WITH RECURSIVE workspace_and_children (id) AS (
            SELECT id
            FROM workspace
            WHERE id = ?::uuid
          UNION
            SELECT w.id
            FROM workspace w, workspace_and_children s
            WHERE w.parent_workspace_id = s.id
        )
        DELETE FROM workspace_datacenter_room
        $remove_where_clause
          AND workspace_id IN (SELECT id FROM workspace_and_children)
      }, $ws_id, @remove_id_binds
    );
  }

  # Add new room IDs to workspace only, not children
  if ( scalar @ids_to_add ) {
    my ( $add_where_clause, @add_id_binds ) =
      $sql->where( { id => { -in => \@ids_to_add } } );
    $db->query(
      qq{
        INSERT INTO workspace_datacenter_room (workspace_id, datacenter_room_id)
        SELECT ?::uuid, id
        FROM datacenter_room
        $add_where_clause
      }, $ws_id, @add_id_binds
    );
  }

  $tx->commit;
  my $rooms = $db->query(
    q{
      SELECT dr.id, dr.az, dr.alias, dr.vendor_name
      FROM datacenter_room dr
      JOIN workspace_datacenter_room wdr
      ON dr.id = wdr.datacenter_room_id
      WHERE wdr.workspace_id = ?::uuid
    }, $ws_id
  )->hashes->to_array;
  return success($rooms);
}

1;