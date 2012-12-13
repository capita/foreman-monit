require "foreman/engine"

module ForemanMonit
  class Exporter
    def initialize(options)
      @app = options[:app]
      @user = options[:user]
      @target = options[:target]
      @env = options[:env]

      @engine = Foreman::Engine.new
      load_procfile
      load_env
      @port = @engine.base_port
    end

    def run!
      Dir.mkdir(@target) unless File.exist?(@target)
      File.delete("#{@target}/*.conf")
      @engine.each_process do |name, process|
        file_name = File.join(@target, "#{@app}-#{name}.conf")
        File.open(file_name, 'w') { |f| f.write ERB.new(File.read(File.expand_path("../../../templates/monitrc.erb", __FILE__))).result(binding) }
      end
    end

    def info
      puts @engine.processes.inspect
    end

    def port
      @port += 1
      @port-1
    end

    def base_dir
      Dir.getwd
    end

    def pid_file(name)
      File.expand_path(File.join(@target, "#{@app}-#{name}.pid"))
    end

    def log_file(name)
      File.expand_path(File.join(@target, "#{@app}-#{name}.log"))
    end

    def rails_env
      @env
    end

    private

    def load_env
      default_env = File.join(@engine.root, ".env")
      @engine.load_env default_env if File.exists?(default_env)
    end

    def load_procfile
      @engine.load_procfile('Procfile')
    end
  end
end
