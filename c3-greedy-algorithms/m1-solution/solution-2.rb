# Minimizing the weighted sum of completion times algorithm

# Run the greedy algorithm that schedules jobs (optimally) in decreasing order of the ratio (weight/length).

# Report the sum of weighted completion times of the resulting schedule

###########################################################################################################################

class JobScheduler

  attr_reader :joblist, :number_of_jobs, :ratio, :sorted_joblist, :sum

  # joblist - loaded raw data
  # number_of_jobs - number of jobs read from input file
  # ratio - sorted hash of job ratios
  # sorted_joblist - properly scheduled jobs
  # sum - the sum of weighted completion times of the resulting schedule

  def initialize(filedata)
    @ratio = {}
    @number_of_jobs = 0
    @sorted_joblist = []
    @sum = 0

    # load raw data from the input file
    @joblist = load_data(filedata)

    # calculate criteria using difference strategy and sort it in decreasing order
    calculate_and_sort_ratio

    # schedule jobs in proper order
    schedule_jobs

    # calculate the sum of weighted completion times of the resulting schedule
    calculate_sum
  end

  # Method for loading data from file
  def load_data(filename)
    jobs = []
    if File.exist? filename
      File.foreach (filename) do |job|
        job = job.chomp.split(" ")
        if job.length == 1
          @number_of_jobs = job[0].to_i
          next
        else
          job = [job[0].to_f, job[1].to_f]
        end
        jobs << job
      end
    end
    return jobs
  end

  # calculate using difference strategy and sort it in decreasing order
  def calculate_and_sort_ratio
    @joblist.each_with_index do |job, index|
      @ratio[index] = job[0] / job[1]
    end
    # sort jobs by ratio in decreasing order
    @ratio = @ratio.sort_by {|k,v| v}.reverse.to_h
  end

  def schedule_jobs
    @ratio.each do |job_index, ratio_value|
      @sorted_joblist << @joblist[job_index]
    end
  end


  # calculate the sum of scheduled joblist
  def calculate_sum
    completion = 0
    @sorted_joblist.each do |job|
      completion += job[1]
      @sum += job[0] * completion
    end
  end

end

###########################################################################################################################

input_file = 'jobs.txt'
# input_file = 'testArray.txt'

solution = JobScheduler.new(input_file)


puts "\n--------------------------------------------------------------------"
puts "2. RATIO STRATEGY. The sum of weighted completion times: #{solution.sum.to_i}"
puts "--------------------------------------------------------------------\n"
