# This is used by the Foreman gem, which we use to start our web server and the background jobs.
web: bin/run_app.sh
cron: bundle exec script/run_clockwork.rb
resque: bundle exec rake resque:work QUEUE=*