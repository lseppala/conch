use Mojo::Base -strict;
use Test::More;
use Test::ConchTmpDB;
use Mojo::Pg;

use Conch::Pg;

use_ok("Conch::Model::User");
use_ok("Conch::Model::Workspace");

my $pgtmp = mk_tmp_db() or die;
my $pg    = Conch::Pg->new( $pgtmp->uri );

new_ok('Conch::Model::Workspace');

my $ws_model = new_ok( "Conch::Model::Workspace" );

my $global_ws;

subtest "Lookup workspace by name" => sub {
	my $attempt = $ws_model->lookup_by_name('NON EXISTANT');
	is( $attempt, undef, "Lookup for bad workspace fails" );

	$global_ws = $ws_model->lookup_by_name('GLOBAL');
	isa_ok( $global_ws, 'Conch::Class::Workspace' );
	is( $global_ws->name, 'GLOBAL' );
};

my $new_user = Conch::Model::User->create( 'foo@bar.com', 'password' );

subtest "Add user to Workspace" => sub {
	is( $ws_model->add_user_to_workspace( $new_user->id, $global_ws->id, 1 ),
		1, "Successfully added user to workspace" );
};

subtest "Get user Workspace" => sub {
	my $user_ws = $ws_model->get_user_workspace( $new_user->id, $global_ws->id );
	isa_ok( $user_ws, 'Conch::Class::Workspace' );
	is( $user_ws->id,      $global_ws->id );
	is( $user_ws->role_id, 1, 'has assigned role ID' );
	is( $user_ws->role,    'Administrator', 'has assigned role name' );
};

my $sub_ws;
subtest "Create subworkspace" => sub {
	$sub_ws =
		$ws_model->create_sub_workspace( $new_user->id, $global_ws->id, 1, 'Sub WS',
		'Sub Workspace Test' );
	isa_ok( $sub_ws, 'Conch::Class::Workspace' );
};

# Test after creating sub workspace so it contains more than 1 workspace
subtest "List all user workspaces" => sub {
	my $user_wss = $ws_model->get_user_workspaces( $new_user->id );
	isa_ok( $user_wss, 'ARRAY' );
	is( scalar @$user_wss, 2, 'Contains two workspaces' );
	ok( grep( sub { $_->id eq $global_ws->id }, @$user_wss ),
		'Contains GLOBAL workspace' );
	ok( grep( sub { $_->id eq $sub_ws->id }, @$user_wss ),
		'Contains sub-workspace' );
};

subtest "List user sub workspaces" => sub {
	my $user_sub_wss =
		$ws_model->get_user_sub_workspaces( $new_user->id, $global_ws->id );
	isa_ok( $user_sub_wss, 'ARRAY' );
	is( scalar @$user_sub_wss, 1, 'Contains one sub workspace' );
	ok( grep( sub { $_->id eq $sub_ws->id }, @$user_sub_wss ),
		'Contains sub-workspace' );
	isa_ok( $user_sub_wss->[0], 'Conch::Class::Workspace' );

	# Create a sub-workspace for the sub-workspace. It should be listed
	subtest "Get all descendents" => sub {
		my $sub_ws_attempt =
			$ws_model->create_sub_workspace( $new_user->id, $sub_ws->id, 1,
			'Sub-Sub WS', 'Sub Workspace Test' );
		isa_ok( $sub_ws_attempt, 'Conch::Class::Workspace' );
		$user_sub_wss =
			$ws_model->get_user_sub_workspaces( $new_user->id, $global_ws->id );
		is( scalar @$user_sub_wss, 2, 'Contains two sub workspaces' );
		ok( grep( sub { $_->id eq $sub_ws_attempt->value->id }, @$user_sub_wss ),
			'Contains sub-workspace' );
	};
};

done_testing();
