require 'spec/rake/spectask'

desc "Run the specs."
task :spec do
  Spec::Rake::SpecTask.new do |task|
    task.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
    task.spec_files = FileList['spec/*_spec.rb']
  end
end
