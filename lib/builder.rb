require 'fileutils'
require 'open-uri'
require 'nokogiri'
require 'logger'

module GasmLogging

  def log
    @log = Logger.new(STDOUT) if @log.nil?
    @log
  end
end

class Project 
  include GasmLogging

  attr_accessor :source_url, :build_cmd

  def initialize(opts = {})
    @source_url = opts[:source_url]
    @build_cmd = opts[:build_cmd]
  end

  def build(opts = {})
    log.info "Building project #{@source_url}"

    download_source(opts[:source_dir])
    cur_dir = Dir.getwd
    FileUtils.cd "#{opts[:source_dir]}/sample_project"
    %x( #{@build_cmd} )
    FileUtils.cd cur_dir
  end

  def download_source(to_path)
    log.info "Downloading source to #{to_path}"
    cur_dir = Dir.pwd
    FileUtils.mkdir_p to_path
    Dir.chdir to_path
    log.info "Cloning git repository #{@source_url}"
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

class GasmProgram

  class Configuration
    attr_accessor :gasm_dir
  end

  def configure(&block)
    config = Configuration.new
    yield config
    @config = config
  end

  def list(&block)
    doc = Nokogiri::HTML(open("http://localhost:4567/index.html"))
    doc.css("ul#projects li a").each do |p|
      yield p.text
    end
  end

  def install(project)
    doc = Nokogiri::HTML(open("http://localhost:4567/index.html"))
    project_url = doc.css("ul#projects li##{project} a").first.attr("href")

    project_doc = Nokogiri::HTML(open(project_url))
    source_url = project_doc.css("a#source_url").attr("href")
    build_cmd = project_doc.css("p#build_command").text

    p = Project.new(:source_url => source_url, :build_cmd => build_cmd)
    p.build(:source_dir => @config.gasm_dir)

    #FileUtils.mkdir_p "#{@config.gasm_dir}/sample_project/.git"
    #FileUtils.mkdir_p "#{@config.gasm_dir}/sample_project/build"
    #FileUtils.touch "#{@config.gasm_dir}/sample_project/build/sample.exe"
  end
end
