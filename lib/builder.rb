require 'fileutils'

class Project 
  attr_accessor :source_url, :build_cmd

  def initialize(opts = {})
    @source_url = opts[:source_url]
    @build_cmd = opts[:build_cmd]
  end

  def build(opts = {})

    download_source(opts[:source_dir])
    cur_dir = Dir.getwd
    FileUtils.cd "#{opts[:source_dir]}/sample_project"
    %x( #{@build_cmd} )
    FileUtils.cd cur_dir
  end

  def download_source(to_path)
    cur_dir = Dir.pwd
    FileUtils.mkdir_p to_path
    Dir.chdir to_path
    %x( git clone #{@source_url} )
    Dir.chdir cur_dir
  end
end

module SourceControl

  def self.create(url)
    if url =~ /^git:\/\//
      Git.new
    elsif url =~ /^svn:\/\//
      Svn.new
    end
  end

  class Git
    def download_source!
      
    end
  end

  class Svn
  end
end
