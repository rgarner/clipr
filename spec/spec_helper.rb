$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler'
Bundler.setup

require 'tcx_file'

def content_file(filename)
  filename = File.join(File.dirname(__FILE__), 'fixtures', filename)
  File.read(filename)
end