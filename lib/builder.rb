require 'fileutils'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'rake'

module GasmLogging

  def log
    @log = Logger.new(STDOUT) if @log.nil?
    @log.level = Logger::WARN
    @log
  end
end

class Project 
  include GasmLogging

  attr_accessor :source_url, :build_cmd, :project_url, :output_path, :project_name

  def initialize(opts = {})
    @project_name = opts[:project_name]
    @source_url = opts[:source_url].to_s
    @build_cmd = opts[:build_cmd]
    @dependencies = {}
    @project_url = opts[:project_url]
    @output_path = opts[:output_path]

    if opts[:dependencies]
      @dependencies = opts[:dependencies]
    end
  end

  def dependencies 
    @dependencies.keys
  end

  def dependency_mask(dependency_url)
    @dependencies[dependency_url]
  end

  def build(project_factory, opts = {})

    raise "No project name given" if @project_name.nil? or @project_name.empty?
    source_dir = File.expand_path(opts[:source_dir])

    log.info "Building project #{@source_url}"
    log.debug "Source Dir: #{source_dir}"
    download_source(source_dir)
    cur_dir = Dir.getwd
    new_work_dir = File.join(source_dir,@project_name)
    log.debug "Changing directory to #{new_work_dir}"

    if @dependencies
      dependencies.each do |dep|
        dependent_files = FileList[File.join(new_work_dir,dependency_mask(dep))]
        d_proj = project_factory.create_project_from_url(dep)
        d_proj_output_path = File.join(source_dir,d_proj.project_name, d_proj.output_path)    
        dependent_files.each { |df| cp "#{d_proj_output_path}/#{df.pathmap('%f')}", df}
      end
    end

    Dir.chdir new_work_dir
    log.info "Building project #{@project_name} using #{@build_cmd}"
    log.debug "Current working directory #{Dir.getwd}"
    log.debug Dir.entries(Dir.getwd)

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
  include GasmLogging

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
    p = create_project_from_url(project_url)

    to_build = [p]
    built = []
    while not to_build.empty?
      building = to_build.pop
      log.debug "Processing dependencies for #{building.source_url}"
      for d in building.dependencies
          log.debug "Checking dependency #{d}"
          log.debug "built contents #{built.inspect}"
          if not built.include?(d)
            log.debug "built included #{d}"
            to_build.push building
            to_build.push create_project_from_url(d)
            building = nil
          else
            log.debug "built did not include #{d}"
          end
      end

      if building
        building.build(self, :source_dir => @config.gasm_dir)
        built << building.project_url
      else
        log.debug "building is null, continuing"
      end
    end

  end

  def create_project_from_url(project_url)

    project_doc = Nokogiri::HTML(open(project_url))
    log.info "Parsing #{project_url}"
    log.debug "Page contents for #{project_url}\n #{project_doc.to_s}"

    project = project_doc.css("#project_name").text
    source_url = project_doc.css("a#source_url").attr("href").value
    build_cmd = project_doc.css("p#build_command").text
    output_path = project_doc.css("#output_path").text

    dependencies = {}
    project_doc.css("ol.dependencies a").each do |d|
      dependencies[d.attr("href")] = d.css("span.file-mask").text
    end

    log.debug "Parsed document #{project_url}, project_name: #{project}, source_url: #{source_url}, build_cmd: #{build_cmd} dependent_urls: #{dependencies.inspect}"

     Project.new(:project_name => project, 
                    :source_url => source_url, 
                    :build_cmd => build_cmd,
                    :dependencies => dependencies,
                    :project_url => project_url,
                    :output_path => output_path)

  end
end
