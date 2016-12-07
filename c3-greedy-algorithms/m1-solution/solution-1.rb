# Minimizing the weighted sum of completion times algorithm

# Report the sum of weighted completion times of the resulting schedule

###########################################################################################################################

class JobScheduler

  attr_reader :joblist, :number_of_jobs, :differences, :sorted_joblist, :sum

  def initialize(filedata)
    @differences = {}
    @number_of_jobs = 0
    @sorted_joblist = []
    @sum = 0

    @joblist = load_data(filedata)

    # puts @joblist.inspect
    # puts @number_of_jobs

    calculate_and_sort_differences

    schedule_jobs

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
          job = [job[0].to_i, job[1].to_i]
        end
        jobs << job
      end
    end
    return jobs
  end

  def calculate_and_sort_differences
    @joblist.each_with_index do |job, index|
      @differences[index] = job[0] - job[1]
    end
    @differences = @differences.sort_by {|k,v| v}.reverse.to_h
  end

  def schedule_jobs
    jobs_to_sort_by_weight = []
    prev_index, prev_value = @differences.first

    @differences.each do |job_index, difference_value|

      if difference_value == prev_value
        jobs_to_sort_by_weight << job_index
      else
        sort_jobs_by_weight(jobs_to_sort_by_weight)

        jobs_to_sort_by_weight = []
        jobs_to_sort_by_weight << job_index
        prev_value = difference_value
      end

      # puts "processed: #{@sorted_joblist.length}, current list: #{jobs_to_sort_by_weight.inspect}, awaiting: #{@sorted_joblist.length + jobs_to_sort_by_weight.length}"
      # gets
    end
    sort_jobs_by_weight(jobs_to_sort_by_weight) if jobs_to_sort_by_weight.length > 0
  end

  def sort_jobs_by_weight(array)
    jobweights = {}
    array.each do |jobindex|
      jobweights[jobindex] = @joblist[jobindex][0]
    end
    jobweights = jobweights.sort_by {|k,v| v}.reverse.to_h
    jobweights.each do |key, value|
      @sorted_joblist << @joblist[key]
    end
    # puts "Sorted jobs: #{@sorted_joblist}"
    # gets
  end

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


puts "\n-------------------------------------------------"
puts "The sum of weighted completion times: #{solution.sum}"
puts "-------------------------------------------------\n"
