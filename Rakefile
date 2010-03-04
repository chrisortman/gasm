require 'rubygems'
require 'rake'
require 'colored'
require 'rake/testtask'

task :create_sample_projects, :dir do |t, args|
  mkdir args.dir unless File.exist? args.dir
  sample_files = FileList["sample_project/Rakefile"]

  ["sample_project","sample_project_a","sample_project_b"].each do |proj|

    sample_path = "#{args.dir}/#{proj}"
    rm_rf sample_path
    mkdir sample_path unless File.exist?(sample_path)
    sample_files.each { |sf| cp sf, "#{sample_path}/#{sf.pathmap('%f')}" }

    old_pwd = Dir.getwd
    cd sample_path
    sh "git init"
    sh "git add . "
    sh "git commit -m 'first commit'"
    touch "#{sample_path}/.git/git-daemon-export-ok"
    cd old_pwd

  end

  sh "git daemon --base-path=#{args.dir}"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.pattern = "test/*_test.rb"
  t.verbose = true
end
