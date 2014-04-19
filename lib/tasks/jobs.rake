namespace :jobs do

  desc "Checks for jobs to process"
  task start_checker: :environment do
    n = 0
    loop do
      Job.run_jobs
      n += 1
      puts "ran operation #{n} time(s)"
      sleep 60
    end
  end

end
