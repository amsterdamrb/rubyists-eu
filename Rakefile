desc "Run the specs."
task :spec do
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new do |task|
    task.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
    task.spec_files = FileList['spec/*_spec.rb']
  end
end

begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.fork = true
    t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'pretty')]
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install the cucumber gem.'
  end
end