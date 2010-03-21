#!/usr/bin/env perl
# 
# TWITTER_USERNAME=xxx TWITTER_PASSWORD=xxx plackup -s Twiggy tweet_displayer.pl
# 
# Via http://gist.github.com/338258
# 
use strict;
use AnyEvent::Twitter::Stream;
use Encode;
use Markapl;
 
my @buf;
 
my $stream = AnyEvent::Twitter::Stream->new(
    username => $ENV{TWITTER_USERNAME},
    password => $ENV{TWITTER_PASSWORD},
    method => 'sample',
    on_tweet => sub {
        my $tweet = shift;
        unshift @buf, $tweet;
        @buf = @buf[0..9] if @buf >= 10;
    },
);
 
sub {
    $stream; # <- reference
    my $mp = html { body { ul { map { li { $_->{text} } } @buf } } };
    return [ 200, [ 'Content-Type', 'text/html' ], [ encode_utf8( $mp->() ) ] ];
};
 
 
