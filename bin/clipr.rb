#!/usr/bin/env ruby

require_relative '../lib/trollop'
require_relative '../lib/clipr'

options = Trollop::options do
   version "Clipr version #{Clipr::VERSION}"
   opt :verbose, 'Show old and new totals'
   opt :after, 'Time after which to clip'
end



