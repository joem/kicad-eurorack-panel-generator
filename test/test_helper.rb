# frozen_string_literal: true

# The test/test_helper.rb is the file where you initialize all the Minitest
# specific configurations, plugins, and reporters. This file is to be included
# at the top of each test file in the test directory with require
# 'test_helper'.

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'minitest/spec'
# require 'minitest/reporters'

# Minitest::Reporters.use!
