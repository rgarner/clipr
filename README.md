# Clipr

An incomplete utility to takes Garmin .tcx files and clip the ends past a certain point, recalculating averages as it
goes.

I made this because I'm sick of one of the following two things happening:

1. I finish a ride but forget to hit stop, and my average speed goes down as I pootle around recovering with the Garmin in my pocket
1. I finish a ride and hit stop, but forget to reset/turn it off and hit the start button again while pootling around recovering with the Garmin in my pocket.

## Usage

After installation via

    gem install clipr

... there's a binary you can use

    clipr too_long.tcx --from 2012-04-13T11:32:11.000Z

Will create a file `too_long_clipped.tcx` with fewer trackpoints. Currently horrifically limited (to one lap, which is
my personal use case. Sorry).