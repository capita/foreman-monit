# Foreman::Monit

# TODO: RubyGems
# TODO: Complete options

Small command-line too to export from Procfile to monit control files

## Installation

Add this line to your application's Gemfile:

    gem 'foreman-monit', github: 'capita/foreman-monit'

And then execute:

    $ bundle

## Usage

'foreman-monit export' outputs a monit control file for every process listed in the given Procfile. foreman-monit
has to be called from the projects root directory and outputs to /tmp/foreman-monit per default. It is most useful in deployment
via Capistrano to automate restarting of processes or changing the processes configuration/definition after or inside
your deployment routine

You have to provide --user, --env, [--chruby] and --app to specify the user that will be running the processes, the RAILS_ENV
to use an a general application-indentifier to name control files and groups accordingly.

Inside your procfile, you can use PORT, PID_FILE and RAILS_ENV in your process command, e.g.

    web: bundle exec puma -p $PORT --pidfile $PID_FILE
    worker: bundle exec rake resque:work PIDFILE=$PID_FILE

Monit will fork the command in a shell for the specified user and will redirect each output to ./<target>/<app>-<process>.log

Just include the directory ./monit/*.conf (or whatever you chose as a target) in your global monitrc and do a 'monit reload'

You can start or stop the app's jobs by issuing

    monit -g <app> start
    monit -g <app> stop

or

    monit -g <app> restart

which will typically be somewhere in your 'cap:restart' definition in your Capfile ,e.g.

    monit stop -g <app>
    foreman-monit export --app <app> --user <user> --env production
    monit reload
    monit start -g <app>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
