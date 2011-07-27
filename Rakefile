require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'rdoc'
require 'rdoc/task'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the mint_rails plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the mint_rails plugin.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MINT-rails'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end




PKG_FILES = FileList[
  '[a-zA-Z]*',
  'generators/**/*',
  'lib/**/*',
  'rails/**/*',
  'tasks/**/*',
  'test/**/*'
]

spec = Gem::Specification.new do |s|
  s.name = "MINT-rails"
  s.version = "0.0.1"
  s.author = "Sebastian Feuerstack"
  s.email = "Sebastian@Feuerstack.org"
  s.homepage = "http://www.multi-access.de/"
  s.platform = Gem::Platform::RUBY
  s.summary = "MINT Rails Frontend"
  s.files = PKG_FILES.to_a
  s.require_path = "lib"
  s.has_rdoc = false
  s.extra_rdoc_files = ["README"]
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
