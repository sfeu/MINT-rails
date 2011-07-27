# desc "Explaining what the task does"
# task :mint_rails do
#   # Task goes here
# end
MINT_RAILS_BASE_DIR = File.join(File.dirname(__FILE__), "../..")

namespace :mint_rails do

  desc "Copy the stylesheets and Javascripts into host app's public directory"
  task :copy_assets => :environment do
    destination_root = RAILS_ROOT + "/public/"
    %w(stylesheets javascripts images).each{|asset|
      destination_path = destination_root + asset
      FileUtils.mkpath(destination_path) unless File.exists?(destination_path)
        FileUtils.mkpath(destination_path + "/mint") unless File.exists?(destination_path + "/mint")

      Dir[File.join(MINT_RAILS_BASE_DIR, 'public', asset, '*')].each do |f|
        FileUtils.cp_r(f, File.expand_path(File.join(destination_root, asset,"mint")))
      end
    }


      destination_path = RAILS_ROOT + "/script"
      FileUtils.mkpath(destination_path + "/mint") unless File.exists?(destination_path + "/mint")

      Dir[File.join(MINT_RAILS_BASE_DIR, 'script', '*')].each do |f|
        FileUtils.cp_r(f, File.expand_path(File.join(destination_path, "mint")))
      end

    puts "Files successfully copied!"
  end
end