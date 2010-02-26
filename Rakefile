require 'rake'

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
