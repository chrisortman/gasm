require 'rubygems'
require 'test/unit'
require 'shoulda/test_unit'
require 'fileutils'

require '../lib/builder'

class SourceControlTest < Test::Unit::TestCase

  context "When creating a source control" do
    
    should "create a git source control for git:// urls" do
      @vcs = SourceControl.create("git://github.com/chrisortman/coulda.git")
      assert_kind_of SourceControl::Git, @vcs
    end

    should "create an svn source control for svn:// urls" do
      @vcs = SourceControl.create("svn://svn.apache.org/svn")
      assert_kind_of SourceControl::Svn, @vcs
    end
  end
  
end



class BuilderTest < Test::Unit::TestCase

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
  context "A project" do
    
    setup do
      FileUtils.rm_rf "gasm_source"
      @project = Project.new(:source_url => "git://localhost/sample_project",
                             :build_cmd => "rake")
    end

    context "with no dependencies" do
      
      context "when building" do
        setup do
          @project.build(:source_dir => "gasm_source") 
        end
        should_create_directory("source checkout", "gasm_source/sample_project/.git")
        should_create_directory("build outputs", "gasm_source/sample_project/build")
        should_create_file("project output", "gasm_source/sample_project/build/sample.exe")
      end
    end
  end

end