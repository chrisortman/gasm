require 'rubygems'
require 'test/unit'
require 'shoulda/test_unit'
require 'fileutils'
require 'redgreen'

require File.expand_path(File.dirname(__FILE__)) + '/../lib/builder'

class Test::Unit::TestCase

  def self.should_create_directory(description, path)
    puts "Checking #{File.expand_path(path)}"
    should_change("the existence of the #{description} directory (#{path})", :from => false, :to => true) do
      File.exist? path
    end
  end

  def self.should_create_file(description, path)
    should_change("the existence of the #{description} file (#{path})", :from => false, :to => true) do
      File.exist? path
    end
  end
end
