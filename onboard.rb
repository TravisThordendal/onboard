# encoding: utf-8

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib'

require 'rubygems'
require 'find'
require 'json'
require 'yaml'
require 'logger'
require 'pp' 

require 'onboard/extensions/object'
require 'onboard/menu/node'

require 'onboard/platform/debian'

class OnBoard
  LONGNAME = 'Ruby OnBoard'
 
  ROOTDIR = File.dirname File.expand_path(__FILE__)
  CONFDIR = ROOTDIR + '/etc/config'

  PLATFORM = Platform::Debian # TODO? make in configurable?

  LOGGER = Logger.new(ROOTDIR + '/' + 'onboard.log')

  MENU_ROOT = Menu::MenuNode.new('ROOT', {
    :href => '/',
    :name => 'Home',
    :desc => 'Home page',
    :n    => 0
  })

  #LOGGER.datetime_format = "%Y-%m-%d %H:%M:%S"
  LOGGER.formatter = proc { |severity, datetime, progname, msg|
    "#{datetime} #{severity}: #{msg}\n"
  }

  LOGGER.info "Ruby OnBoard started."

  def self.find_n_load(dir)
    # sort to resamble /etc/rc*.d/* or run-parts behavior
    Find.find(dir).sort.each do |file|
      if file =~ /\.rb$/
        print "loading: #{file}... "
        STDOUT.flush
        if load file
          print "OK\n"
          STDOUT.flush
        end
      end
    end
  end

  def self.prepare
    # menu
    unless ARGV.include? '--restore-only'
      # modular menu
      find_n_load ROOTDIR + '/etc/menu/'
    end

    # modules
    Dir.foreach(ROOTDIR + '/modules') do |dir|
      dir_fullpath = ROOTDIR + '/modules/' + dir
      if File.directory? dir_fullpath and not dir =~ /^\./
        file = dir_fullpath + '/load.rb'
        if File.readable? file
          load dir_fullpath + '/load.rb'
        else
          STDERR.puts "Warning: Couldn't load modules/#{dir}/load.rb: Skipped!"
        end
      end 
    end

    # restore scripts, sorted like /etc/rc?.d/ SysVInit/Unix/Linux scripts
    unless ARGV.include? '--no-restore'
      restore_scripts = 
          Dir.glob(ROOTDIR + '/etc/restore/[0-9][0-9]*.rb')           +
          Dir.glob(ROOTDIR + '/modules/*/etc/restore/[0-9][0-9]*.rb') 
      restore_scripts.sort!{|x,y| File.basename(x) <=> File.basename(y)}
      restore_scripts.each do |script|
        print "loading: #{script}... "
        STDOUT.flush
        load script and puts "OK"
      end
    end

  end

  def self.save!
    LOGGER.info 'Saving configuration...'
    find_n_load ROOTDIR + '/etc/save/'

    # modules
    Dir.glob(ROOTDIR + '/modules/*/etc/save/*.rb').each do |script| 
      print "loading: #{script}... " and STDOUT.flush
      load script and puts ' OK'
    end
  end

end

OnBoard.prepare
exit if ARGV.include? '--restore-only'
require OnBoard::ROOTDIR + '/controller.rb'

if $0 == __FILE__
  OnBoard::Controller.run!(:host => '::')
end


