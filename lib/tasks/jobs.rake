namespace :jobs do

  desc "Checks for jobs to process"
  task start_checker: :environment do
    n = 0
    loop do
      Job.run_new_jobs
      ["minutely", "hourly", "daily", "weekly", "monthly"].each{ |f| Job.check_jobs(f)}
      n += 1
      puts "ran operation #{n} time"
      sleep 60
    end
  end

end
