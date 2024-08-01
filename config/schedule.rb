set :output, "log/whenever.log"

job_type :rake, "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"

every 4.hours do
  rake "fetch_newsdata:fetch_headlines"
  rake "fetch_newsdata:fetch_categorynews"
end
