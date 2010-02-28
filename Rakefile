require 'rubygems'
require 'rake'
require 'colored'
require 'rake/testtask'

def banner(title, pad = 85)
  puts "\n#{title} ".ljust(pad, "*").yellow
end

def stripe
  puts ("-" * 84 + "\n").yellow
end

task :create_sample_project, :dir do |t, args|
  sample_path = "#{args.dir}/sample_project"
  mkdir args.dir unless File.exist? args.dir
  rm_rf sample_path
  cp_r 'sample_project', args.dir
  cd sample_path
  sh "git init"
  sh "git add . "
  sh "git commit -m 'first commit'"
  touch "#{sample_path}/.git/git-daemon-export-ok"
  sh "git daemon --base-path=#{args.dir}"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.pattern = "test/*_test.rb"
  t.verbose = true
end
