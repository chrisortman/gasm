require 'rubygems'
require 'rake'
require 'colored'
require 'rake/testtask'

desc "Setup sample git repos and start git-daemon"
task :create_sample_projects, :dir do |t, args|
  args_dir = args.dir || File.expand_path("~/tmp")
  mkdir args.dir unless File.exist? args_dir
  sample_files = FileList["sample_project/Rakefile"]

  ["sample_project","sample_project_a","sample_project_b"].each do |proj|

    sample_path = "#{args_dir}/#{proj}"
    rm_rf sample_path
    mkdir sample_path unless File.exist?(sample_path)
    sample_files.each { |sf| cp sf, "#{sample_path}/#{sf.pathmap('%f')}" }

    old_pwd = Dir.getwd
    cd sample_path
    sh "git init"

    if proj == "sample_project_a"
      mkdir "lib"
      touch "#{sample_path}/lib/sample.exe"
    end
    sh "git add . "
    sh "git commit -m 'first commit'"
    touch "#{sample_path}/.git/git-daemon-export-ok"
    cd old_pwd

  end

  sh "git daemon --base-path=#{args_dir}"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.pattern = "test/*_test.rb"
  t.verbose = true
end
