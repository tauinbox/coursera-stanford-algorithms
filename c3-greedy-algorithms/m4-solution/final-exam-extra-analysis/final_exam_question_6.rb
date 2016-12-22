# Schedule jobs in order of chosen criterion

# 1 - No greedy rule used (unsorted order)
# 2 - Sorting by d * p
# 3 - Sorting by p
# 4 - Sorting by d

# We are given as input a set of n jobs, where job j has a processing time pj and a deadline dj. 
# Recall the definition of completion times Cj from the video lectures. 
# Given a schedule (i.e., an ordering of the jobs), we define the lateness lj of job j as the amount of time Cj−dj after its deadline that the job completes, or as 0 if Cj≤dj.
# Our goal is to minimize the total lateness

###########################################################################################################################

class JobScheduler

  attr_reader :min_total_lateness

  # joblist - loaded raw data
  # criterion - sorted hash of job criteria
  # sorted_joblist - properly scheduled jobs
  # sum - the sum of weighted completion times of the resulting schedule
  # max_lateness - the maximum lateness (Cj - Dj where Dj is deadline of job j)
  # total_lateness - sum of all latenesses for the whole schedule

  def initialize(filedata)

    # load raw data from the input file
    @joblist = load_data(filedata)

    unprocessed = calculate_and_schedule(1)
    @min_total_lateness = { lateness: unprocessed[:total_lateness], criterion: 1}

    # processing
    2.upto(4) do |criterion|
      result = calculate_and_schedule criterion
      @min_total_lateness = { lateness: result[:total_lateness], criterion: criterion } if result[:total_lateness] < @min_total_lateness[:lateness]
    end

  end

  # Method for loading data from file
  def load_data(filename)
    jobs = []
    if File.exist? filename
      File.foreach (filename) do |job|
        job = job.chomp.split(" ")
        job = [job[1].to_i, job[0].to_i]
        jobs << job
      end
    end
    return jobs
  end

  # calculate using difference strategy and sort it in increasing order
  def calculate_and_schedule(mode = 1)
    @criterion = {}
    # puts "\n----------\nNo greedy rule used (unsorted order)" if mode == 1
    # puts "\n----------\nSorting by d * p" if mode == 2
    # puts "\n----------\nSorting by p" if mode == 3
    # puts "\n----------\nSorting by d" if mode == 4
    @joblist.each_with_index do |job, index|
      rule = 1 if mode == 1
      rule = job[0] * job[1] if mode == 2
      rule = job[1] if mode == 3
      rule = job[0] if mode == 4
      @criterion[index] = rule
    end
    # sort jobs by criterion in increasing order
    @criterion = @criterion.sort_by {|k,v| v}.to_h

    # schedule jobs in order of chosen criterion
    schedule_jobs

    # calculate the sum of weighted completion times of the resulting schedule and also max_lateness and total_lateness
    calculate_sum
  end

  def schedule_jobs
    @sorted_joblist = []
    @criterion.each do |job_index, criterion_value|
      @sorted_joblist << @joblist[job_index]
    end
  end


  # calculate the sum of scheduled joblist
  def calculate_sum
    sum = 0
    total_lateness = 0
    max_lateness = 0    
    completion = 0
    @sorted_joblist.each_with_index do |job, idx|
      completion += job[1]
      sum += job[0] * completion
      l = completion - job[0]
      l = 0 if l < 0
      max_lateness = l if l > max_lateness
      total_lateness += l
      # puts "# #{idx + 1} - length: #{job[1]}, deadline: #{job[0]}, completion: #{completion}, l: #{l}"
    end
    return { total_completion_time: sum, max_lateness: max_lateness, total_lateness: total_lateness }
  end

end

###########################################################################################################################

puts "\nTake a first set of jobs:"
solution = JobScheduler.new('jobs1.txt')

puts "\n--------------------------------------------------------------------"
puts "The minimum total lateness is #{solution.min_total_lateness[:lateness]}"
puts "The best greedy rule for the given input is #{solution.min_total_lateness[:criterion]}"
puts "--------------------------------------------------------------------\n"

puts "\nTake a second set of jobs:"
solution = JobScheduler.new('jobs2.txt')

puts "\n--------------------------------------------------------------------"
puts "The minimum total lateness is #{solution.min_total_lateness[:lateness]}"
puts "The best greedy rule for the given input is #{solution.min_total_lateness[:criterion]}"
puts "--------------------------------------------------------------------\n"

puts "\nUPSHOT: there is no optimal criterion (greedy rule) in given list that produces an ordering that always minimizes the total lateness"