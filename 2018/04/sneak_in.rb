require "date"

GUARDS = {}

class Guard
  attr_reader :id, :total_sleep_time

  def initialize(id)
    @id = id
    @total_sleep_time = 0
    @asleep_since = nil

    @schedule = Hash.new(0)
  end

  def handle_activity!(time, activity)
    return sleep!(time) if /sleep/.match(activity)
    return wake_up!(time) if /wakes/.match(activity)
    return start_shift!(time) if /Guard/.match(activity)

    raise "No activity recognized! #{time}: #{activity}"
  end

  def sleep!(time)
    @asleep_since = time
  end

  def wake_up!(time)
    return unless @asleep_since

    now = @asleep_since
    #puts "counting 1 for #{now}"
    @schedule[now.strftime("%M").to_i] += 1 # asleep in this minute
    @total_sleep_time += 1
    while (now = (now.to_time + 60).to_datetime) <= (time.to_time - 60).to_datetime
      #puts "counting 1 for #{now}"
      @schedule[now.strftime("%M").to_i] += 1
      @total_sleep_time += 1
    end

    #puts "now total: #{@total_sleep_time}"
    #puts @schedule

    @asleep_since = nil
  end

  def sleepiest_minute()
    @schedule.max_by { |minute, count| count }
  end

  def start_shift!(time)
    wake_up!(time)
  end

  def to_s
    "<Guard #{@id} t:#{@total_sleep_time}>"
  end
end

def parse_observation(str)
  r = /(\[.+\]) (.+)/.match(str)
  [DateTime.parse(r[1]), r[2]]
end

def determine_guard(current_guard, activity)
  matched = /Guard #(\d+) begins shift/.match(activity)
  guard_id = matched[1].to_i if matched

  if guard_id
    unless GUARDS[guard_id]
      GUARDS[guard_id] = Guard.new(guard_id)
    end

    return GUARDS[guard_id]
  end

  current_guard
end

def find_sleepy_guard(guards)
  guards.max_by { |k, g| g.total_sleep_time }[1]
end

def sneak_in()
  all_obs = File.open("input04").map { |o| parse_observation(o) }.sort_by {|d| d[0] }

  current_guard = nil

  all_obs.each do |o|
    time = o[0]; activity = o[1]

    #puts "#{time}: #{activity}"

    new_guard = determine_guard(current_guard, activity)
    if current_guard != nil && new_guard != current_guard
      current_guard.wake_up!(time)
    end
    current_guard = new_guard
    current_guard.handle_activity!(time, activity)
  end

  sleepy_guard = find_sleepy_guard(GUARDS)
  best_minute = sleepy_guard.sleepiest_minute()[0]

  top_guard = GUARDS.max_by { |k, g| (g.sleepiest_minute() || [k,0])[1] }[1]
  top_guard_best = top_guard.sleepiest_minute()[0]

  #GUARDS.each { |id, g| puts g }

  puts "####RESULT####"
  [sleepy_guard, best_minute, sleepy_guard.id * best_minute, top_guard.id * top_guard_best]
end

puts sneak_in()