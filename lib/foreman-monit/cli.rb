require 'thor'
require 'thor/actions'
require 'rubygems/config_file'

Gem.configuration

module ForemanMonit
  class CLI < Thor
    include Thor::Actions

    method_option 'app', :type => :string, :required => true
    method_option 'user', :type => :string, :required => true
    method_option 'procfile', :type => :string, :default => 'Procfile'
    method_option 'target', :type => :string, :default => '/tmp/foreman-monit'
    method_option 'env', :type => :string, :required => true
    method_option 'chruby', :type => :string, :required => false

    desc 'export', 'Exports shell-wrapper in ./bin and outputs a monit control file for each process in Procfile'
    def export
      ForemanMonit.export_to_monitrc(options.dup)
    end
  end
end