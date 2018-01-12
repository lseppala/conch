use Mojo::Base -strict;
use Test::More;
use Test::ConchTmpDB;
use Mojo::Pg;

use Conch::Model::User;
use Conch::Model::Workspace;
use Data::Printer;

my $pgtmp = mk_tmp_db() or die;
my $pg = Mojo::Pg->new( $pgtmp->uri );

new_ok('Conch::Model::Workspace');

my $ws_model = Conch::Model::Workspace->new( pg => $pg, );

my $global_ws;

subtest "Lookup workspace by name" => sub {
  can_ok( $ws_model, 'lookup_by_name' );
  my $attempt = $ws_model->lookup_by_name('NON EXISTANT');
  ok( $attempt->is_fail );

  $attempt = $ws_model->lookup_by_name('GLOBAL');
  ok( $attempt->is_success );
  isa_ok( $attempt->value, 'Conch::Class::Workspace' );
  $global_ws = $attempt->value;
  is( $global_ws->name, 'GLOBAL' );
};

my $user_model = Conch::Model::User->new(
  hash_password         => sub { reverse shift },
  pg                    => $pg,
  validate_against_hash => sub { reverse(shift) eq shift }
);
my $new_user = $user_model->create( 'foo@bar.com', 'password' )->value;

subtest "Add user to Workspace" => sub {
  can_ok( $ws_model, 'add_user_to_workspace' );
  is( $ws_model->add_user_to_workspace( $new_user->id, $global_ws->id, 1 ),
    1, "Successfully added user to workspace" );
};

subtest "Get user Workspace" => sub {
  can_ok( $ws_model, 'get_user_workspace' );
  my $user_ws = $ws_model->get_user_workspace( $new_user->id, $global_ws->id );
  isa_ok($user_ws, 'Attempt::Success');
  ok( $user_ws->is_success );
  is( $user_ws->value->id, $global_ws->id );
  is( $user_ws->value->role_id, 1, 'has assigned role ID' );
  is( $user_ws->value->role, 'Administrator', 'has assigned role name' );
};

my $sub_ws;
subtest "Create subworkspace" => sub {
  can_ok( $ws_model, 'create_sub_workspace' );
  my $sub_ws_attempt =
    $ws_model->create_sub_workspace( $new_user->id, $global_ws->id, 1,
    'Sub WS', 'Sub Workspace Test' );
  isa_ok($sub_ws_attempt, 'Attempt::Success');
  ok( $sub_ws_attempt->is_success );
  $sub_ws = $sub_ws_attempt->value;
};

# Test after creating sub workspace so it contains more than 1 workspace
subtest "List all user workspaces" => sub {
  can_ok( $ws_model, 'get_user_workspaces' );
  my $user_wss = $ws_model->get_user_workspaces( $new_user->id );
  isa_ok($user_wss , 'ARRAY');
  is( scalar @$user_wss, 2, 'Contains two workspaces' );
  ok( grep(sub { $_->id eq $global_ws->id }, @$user_wss),'Contains GLOBAL workspace' );
  ok( grep(sub { $_->id eq $sub_ws->id }, @$user_wss),'Contains sub-workspace' );
};

subtest "List user sub workspaces" => sub {
  can_ok( $ws_model, 'get_user_sub_workspaces' );
  my $user_sub_wss = $ws_model->get_user_sub_workspaces( $new_user->id, $global_ws->id );
  isa_ok($user_sub_wss  , 'ARRAY');
  is( scalar @$user_sub_wss, 1, 'Contains one sub workspace' );
  ok( grep(sub { $_->id eq $sub_ws->id }, @$user_sub_wss),'Contains sub-workspace' );

  # Create a sub-workspace for the sub-workspace. It should be listed
  subtest "Get all descendents" => sub {
    my $sub_ws_attempt =
    $ws_model->create_sub_workspace( $new_user->id, $sub_ws->id, 1,
      'Sub-Sub WS', 'Sub Workspace Test' );
    isa_ok($sub_ws_attempt, 'Attempt::Success');
    $user_sub_wss = $ws_model->get_user_sub_workspaces( $new_user->id, $global_ws->id );
    is( scalar @$user_sub_wss, 2, 'Contains two sub workspaces' );
    ok( grep(sub { $_->id eq $sub_ws_attempt->value->id }, @$user_sub_wss),'Contains sub-workspace' );
  };
};

done_testing();