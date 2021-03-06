#!perl
# vim:ts=4:sw=4:expandtab
#
# Please read the following documents before working on tests:
# • http://build.i3wm.org/docs/testsuite.html
#   (or docs/testsuite)
#
# • http://build.i3wm.org/docs/lib-i3test.html
#   (alternatively: perldoc ./testcases/lib/i3test.pm)
#
# • http://build.i3wm.org/docs/ipc.html
#   (or docs/ipc)
#
# • http://onyxneon.com/books/modern_perl/modern_perl_a4.pdf
#   (unless you are already familiar with Perl)
#
# Ticket: #2229
# Bug still in: 4.11-262-geb631ce
use i3test i3_autostart => 0;

my $config = <<EOT;
# i3 config file (v4)
font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1

fake-outputs 400x400+0+0,400x400+400+0
workspace_auto_back_and_forth no
EOT

my $pid = launch_with_config($config);
my $i3 = i3(get_socket_path());

# Set it up such that workspace 3 is on the left output and
# workspace 4 is on the right output
cmd 'focus output fake-0';
open_window;
cmd 'workspace 3';
cmd 'focus output fake-1';
cmd 'workspace 4';
open_window;

cmd 'move workspace to output left';

# ensure that workspace 3 has now vanished
my $get_ws = $i3->get_workspaces->recv;
my @ws_names = map { $_->{name} } @$get_ws;
ok(!('3' ~~ @ws_names), 'workspace 3 has been closed');

exit_gracefully($pid);

done_testing;
