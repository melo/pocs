# The simplest Mason server ever #

This is a PSGI-complient Mason server. It's the simplest I could come up with
in 20 minutes.

It deserves a Plack::App::Mason or whatever... If I get the time...


## How to try it out ##

Just clone this repo, install the deps (cpanfile provided) and plackup the demo.

For the lazy:

    git clone https://github.com/melo/pocs.git melo-pocs
    cd melo-pocs/mason_simple_server
    cpanm --installdeps .
    plackup

(the simplicity of the process... we owe a lot to @miyagawa)


# Author #

Pedro Melo <melo@simplicidade.org>, 2013


# License #

Same terms as Perl itself...
