begin
  require 'rcov/rcovtask'
rescue LoadError
  # do nothing
end

if Object.const_defined?(:Rcov)
  namespace :test do
    Rcov::RcovTask.new(:rcov => "db:test:prepare") do |t|
      t.libs << 'test'
      t.test_files = FileList['test/**/*_test.rb']
      t.rcov_opts = %w[--sort coverage -T --only-uncovered --rails]
      t.rcov_opts << '-x "/opt/local/lib/ruby"'
      t.rcov_opts << '-x "/System/Library/"'
      t.rcov_opts << '-x "/Library/Ruby/"'
    end

    desc "Generate code Coverage with rcov and open report"
    task :coverage => "test:rcov" do
      system "open coverage/index.html" if PLATFORM['darwin']
    end
    
    namespace :units do
      Rcov::RcovTask.new(:rcov => "db:test:prepare") do |t|
        t.libs << 'test'
        t.test_files = FileList['test/unit/**/*_test.rb']
        t.output_dir = 'unit_coverage'
        t.rcov_opts = %w[--sort coverage -T --only-uncovered --rails]
        t.rcov_opts << '-x "/opt/local/lib/ruby"'
        t.rcov_opts << '-x "/System/Library/"'
        t.rcov_opts << '-x "/Library/Ruby/"'
        t.rcov_opts << '-x "app/helpers"'
        t.rcov_opts << '-x "app/controllers"'
        t.rcov_opts << '-x "lib"'
      end
      
      desc "Generate code Coverage for Unit Tests with rcov and open report"
      task :coverage => "test:units:rcov" do
        system "open unit_coverage/index.html" if PLATFORM['darwin']
      end
    end
    
    namespace :functionals do
      Rcov::RcovTask.new(:rcov => "db:test:prepare") do |t|
        t.libs << 'test'
        t.test_files = FileList['test/functional/**/*_test.rb']
        t.output_dir = 'functional_coverage'
        t.rcov_opts = %w[--sort coverage -T --only-uncovered --rails]
        t.rcov_opts << '-x "/opt/local/lib/ruby"'
        t.rcov_opts << '-x "/System/Library/"'
        t.rcov_opts << '-x "/Library/Ruby/"'
        t.rcov_opts << '-x "app/helpers"'
        t.rcov_opts << '-x "app/models"'
        t.rcov_opts << '-x "lib"'
      end
      
      desc "Generate code Coverage for Unit Tests with rcov and open report"
      task :coverage => "test:functionals:rcov" do
        system "open functional_coverage/index.html" if PLATFORM['darwin']
      end
    end
    
    namespace :coverage do
      desc "Generate code Coverage with rcov and open report"
      task :all => ["test:rcov", "test:functionals:rcov", "test:units:rcov"] do
        system "open coverage/index.html" if PLATFORM['darwin']
        system "open unit_coverage/index.html" if PLATFORM['darwin']
        system "open functional_coverage/index.html" if PLATFORM['darwin']
      end
    end
  end
end
