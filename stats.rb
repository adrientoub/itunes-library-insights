require 'active_support/duration'

class Stats
  def self.generate_stats(songs, year)
    date = DateTime.new(year, 1, 1)
    end_year = DateTime.new(year + 1, 1, 1)
    v = songs.select do |track|
      track.date_added > date && track.date_added < end_year
    end
    puts "#{v.count} new songs in #{year}"
    total_duration = 0
    v.each do |k|
      total_duration += k.total_duration
    end
    puts "Listed to music from #{year} during #{total_duration} seconds"
    puts "Listed to music from #{year} during #{total_duration / 60} minutes"
    p ActiveSupport::Duration.build(total_duration).parts
    v.sort_by(&:total_duration).reverse.each do |track|
      puts "#{track.total_duration / 60}: #{track.name} - by #{track.artist}"
    end
  end
end
