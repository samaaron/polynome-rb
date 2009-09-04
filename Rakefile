begin
  require File.dirname(__FILE__) + '/vendor/rspec/lib/spec/rake/spectask'
rescue LoadError
  puts 'To use rspec for testing you must install the rspec submodule:'
  puts '$ git submodule init ; git submodule update'
  exit
end

desc "Run the specs under spec"
Spec::Rake::SpecTask.new do |t|
  t.name = 'spec_main'
  t.spec_opts = ['--options', File.dirname(__FILE__) + "/spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb'] +
                 FileList['vendor/tosca/spec/**/*_spec.rb'] +
                 FileList['vendor/threaded_logger/spec/**/*_spec.rb']
  t.fail_on_error = false
  t.libs << 'vendor/threaded_logger/lib/'
  t.libs << 'lib'
  t.libs << 'vendor/tosca/lib'
end

desc "Run the specs under spec and mention which Ruby version is currently running"
task :spec => [:spec_main] do
  puts "(Interpreted with #{Gem.ruby_engine}, version #{Gem.ruby_version})\n\n"
end
