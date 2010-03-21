#!/usr/bin/env perl
# 
# TWITTER_USERNAME=xxx TWITTER_PASSWORD=xxx plackup -s Twiggy tweet_displayer.pl
# 
# Via http://gist.github.com/338258
# 
use perl5i::2;
use AnyEvent::Twitter::Stream;
use autobox::Encode;
use Markapl;
 
my $buf = [];
 
# NOTE: $stream should live outside this PSGI file scope
# Change state to our if you're using perl 5.8
state $stream = AnyEvent::Twitter::Stream->new(
    username => $ENV{TWITTER_USERNAME},
    password => $ENV{TWITTER_PASSWORD},
    method => 'sample',
    on_tweet => sub {
        my $tweet = shift;
        $buf->unshift($tweet);
        $buf = $buf->slice(0..9) if $buf->size >= 10;
    },
);
 
sub {
    my $mp = html { body { ul { $buf->map(sub { li { $_->{text} } }) } } };
    return [
        200, 
        [ 'Content-Type', 'text/html; charset=utf-8' ], 
        [ $mp->()->encode('utf8') ],
    ];
};
