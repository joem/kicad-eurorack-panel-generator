# frozen_string_literal: true

# The test/test_helper.rb is the file where you initialize all the Minitest
# specific configurations, plugins, and reporters. This file is to be included
# at the top of each test file in the test directory with require
# 'test_helper'.

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'minitest/spec'

# Use minitest-reporters only if installed.
# https://github.com/minitest-reporters/minitest-reporters
begin
  require 'minitest/reporters'
  # Redgreen-capable version of standard Minitest reporter:
  reporter_options = { detailed_skip: false }
  # Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
  Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(reporter_options)
rescue LoadError
end
