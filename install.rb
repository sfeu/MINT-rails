# Install hook code here
require "rubygems"
require "bundler/setup"
require "MINT-core"

print "\e[1m\e[34mADVISE\e[0m You need to add the following lines into your config/environment.rb file:\n  config.frameworks -= [ :active_record ]\n HOST_IP = '127.0.0.1' \n \n the former one disables active_record which the MINT framework does not require (it also eliminates the sql-lite database requirement. The latter IP needs to be set to the IP from that you computer can be contacted from outside (if you want to offer the application to the internet) otherwise you can set it to the local 127.0.0.1 IP. "
print "After the installation is finished, please run:\nrake mint_rails:copy_assets\n\nThis will copy all required javascripts, images, stylesheets, and startup scripts to the public folder.\n Thereafter you could run:\n./script/mint/startup.sh\n\n to start the MINT platform and access it from http://localhost:3000/mint"