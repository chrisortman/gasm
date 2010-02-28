require File.expand_path(File.dirname(__FILE__)) + '/test_helper.rb'

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

  context "A project" do
    
    setup do
      FileUtils.rm_rf "gasm_source"
      @project = Project.new(:source_url => "git://localhost/sample_project",
                             :build_cmd => "rake")
    end

    teardown do
      FileUtils.rm_rf "gasm_source"
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

class GasmProgramTest < Test::Unit::TestCase

  context "The gasm program" do
    setup do
      FileUtils.rm_rf "gasm_source"
        @gasm = GasmProgram.new
        @gasm.configure do |config|
          config.gasm_dir = "gasm_source"
        end
    end

    teardown do
      FileUtils.rm_rf "gasm_source"
    end

    context "when listing available projects" do

      setup do
        @projects = []
        @gasm.list do |project|
          @projects << project
        end
      end

      should "include the sample project" do
        assert @projects.include? "sample_project"
      end
    end
    
    context "when installing a project by name" do
      
      setup do
        @gasm.install "sample_project"
      end

      should_create_directory("source checkout", "gasm_source/sample_project/.git")
      should_create_directory("build outputs", "gasm_source/sample_project/build")
      should_create_file("project output", "gasm_source/sample_project/build/sample.exe")
    end
  end
end
