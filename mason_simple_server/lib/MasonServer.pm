package MasonServer;

use Moose;    ## No point in using lighter-weight Moo, Mason is Moose based...
use Mason;
use Plack::Request;
use Plack::Response;

has 'mason_options' => (is => 'ro', default => sub { {} });
has 'mason' => (is => 'ro', lazy => 1, builder => '_build_mason');

sub _build_mason { return Mason->new(%{ shift->mason_options }) }

sub to_app {
  my $self = shift;

  my $mason = $self->mason;
  return sub {
    my $req = Plack::Request->new(shift);

    ## Create response with resaonably defaults, your components can change them later
    my $res = $req->new_response(200);
    $res->content_type('text/html');

    my $output = $mason->run($req->path, { $req->param, ctx => { req => $req, res => $res } })->output;
    $res->body($output) if $output;

    return $res->finalize;
  };
}

1;
