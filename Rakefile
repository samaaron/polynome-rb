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
                 FileList['vendor/threaded_logger/spec/**/*_spec.rb'] +
                 FileList['vendor/monome_serial/spec/**/*_spec.rb']


  t.fail_on_error = false
  t.libs << 'vendor/threaded_logger/lib/'
  t.libs << 'lib'
  t.libs << 'vendor/tosca/lib'
  t.libs << 'vendor/monome_serial/lib/'
  t.libs << 'vendor/activesupport/lib'
  RUBY_ENGINE = 'MRI' unless Object.const_defined?("RUBY_ENGINE")
  t.libs << "vendor/extensions/#{RUBY_ENGINE}-#{RUBY_VERSION}-#{RUBY_PLATFORM}"
end

desc "Run the specs under spec and mention which Ruby version is currently running"
task :spec => [:spec_main] do
  puts "(Interpreted with #{RUBY_ENGINE}, version #{RUBY_VERSION})\n\n"
end


desc "Compile Termios C Extensions"
task :compile_termios do
  ruby_cmd = "#{File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])}"
  cd_to_termios_dir = "cd #{File.dirname(__FILE__) + "/vendor/arika-ruby-termios/"}"
  extensions_dir = File.expand_path(File.dirname(__FILE__) + "/vendor/extensions/#{RUBY_ENGINE}-#{RUBY_VERSION}-#{RUBY_PLATFORM}")

  `mkdir -p #{extensions_dir}`
  `#{cd_to_termios_dir} ; #{ruby_cmd} extconf.rb ; make clean ; make ; mv *.bundle #{extensions_dir}`
end
