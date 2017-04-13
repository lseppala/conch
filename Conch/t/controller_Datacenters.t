use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Conch';
use Conch::Controller::Datacenters;

ok( request('/datacenters')->is_success, 'Request should succeed' );
done_testing();
