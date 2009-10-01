desc "Run the specs."
task :spec do
  require 'spec/rake/spectask'
  
  Spec::Rake::SpecTask.new do |task|
    task.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
    task.spec_files = FileList['spec/*_spec.rb']
  end
end

desc "Run the cukes."
task :cukes do
  require 'cucumber'
  require 'cucumber/rake/task'
  
  Cucumber::Rake::Task.new(:features) do |task|
    task.cucumber_opts = "features --format pretty"
  end
end
