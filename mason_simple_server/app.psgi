use strict;
use lib 'lib';
use Plack::Builder;
use Plack::Middleware::Static;
use MasonServer;

my $app = MasonServer->new(
  mason_options => {
    comp_root       => 'comps',
    plugins         => [qw( HTMLFilters DefaultFilter)],
    default_filters => ['HTML'],
  },
);

builder {
  enable 'Static', path => qr{^/(images|js|css)/}, root => './static/';
  $app->to_app;
};
