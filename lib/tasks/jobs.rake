namespace :jobs do

  desc "Checks for jobs to process"
  task start_checker: :environment do
    n = 0
    loop do
      if DateTime.now.second == 0
        Job.run_jobs
        n += 1
        puts "ran operation #{n} times"
        sleep 1
      end
    end
  end

  desc "Destroy orphaned outputs"
  task destroy_orphaned_outputs: :environment do
    outputs = []
    Output.includes(:job).each do |o|
      outputs << o if o.job.blank?
    end
    outputs.each{ |o| o.destroy }
  end

end
