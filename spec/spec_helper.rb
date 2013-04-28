$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler'
Bundler.setup

require 'clipr'

def content_filename(filename)
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end

def content_file(filename)
  File.read(content_filename(filename))
end