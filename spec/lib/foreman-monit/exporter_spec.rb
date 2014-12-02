require File.join(File.dirname(__FILE__), '../../spec_helper')

describe ForemanMonit::Exporter do
  let(:app) { 'FM' }
  let(:env) { 'production' }
  let(:user) { 'foreman-user' }
  let(:target) { '../../tmp' }
  let(:chruby) {}
  let(:procfile) { File.join(File.dirname(__FILE__), '../../Procfile') }

  let(:exporter) do
    ForemanMonit::Exporter.new(app: app, env: env, user: user, target: target, chruby: chruby, procfile: procfile)
  end


  describe '#run!' do
    before(:each) { exporter.run! }

    it 'creates the target directory' do
      expect(Dir.exists?('../../tmp')).to eq(true)
    end

    it 'exports the control file for Procfile#web' do
      expect(File.exists?('../../tmp/FM-web.conf'))
    end

    it 'exports the control file for Procfile#worker' do
      expect(File.exists?('../../tmp/FM-worker.conf'))
    end
  end

  describe '#info' do
    it 'shows the Procfiles entries' do
      expect{ exporter.info }.to write('Foreman').to(:output)
    end

  end

  describe '#port' do
    it 'returns an incrementing port number' do
      expect(exporter.port).to be == 5000
      expect(exporter.port).to be == 5001
      expect(exporter.port).to be == 5002
    end

  end

  describe '#chruby_init' do #
    context 'without @chruby defined' do
      it 'returns an empty string' do
        expect(exporter.chruby_init).to be == ''
      end
    end

    context 'with @chruby defined' do
      let(:chruby) { '2.0.0-p247' }

      it 'returns a chruby prefix' do
        expect(exporter.chruby_init).to be == 'chruby 2.0.0-p247 &&'
      end
    end

  end

  describe '#base_dir' do
    it 'returns the current base directory' do
      expect(exporter.base_dir).to be == Dir.getwd
    end
  end

  describe '#log_file' do
    it 'returns the log file for a given Procfile entry' do
      name = 'my_test_app'
      expect(exporter.log_file(name)).to be == File.expand_path(File.join(target, "#{app}-#{name}.log"))
    end
  end

  describe '#pid_file' do
    it 'returns the pid file for a given Procfile entry' do
      name = 'my_test_app'
      expect(exporter.pid_file(name)).to be == File.expand_path(File.join(target, "#{app}-#{name}.pid"))
    end
  end

  describe '#rails_env' do
    it 'returns the given env' do
      expect(exporter.rails_env).to be == 'production'
    end
  end

  describe '##which_su' do
    it 'returns the path to the su binary' do
      expect(exporter.send(:which_su)).to be == `which su`.chomp
    end
  end

  describe '##which_bash' do
    it 'returns the path to the bash binary' do
      expect(exporter.send(:which_bash)).to be == `which bash`.chomp
    end
  end
end