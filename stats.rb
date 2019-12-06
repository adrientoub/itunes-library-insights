require 'active_support/duration'

class Stats
  def self.generate_stats(songs, year)
    date = DateTime.new(year, 1, 1)
    end_year = DateTime.new(year + 1, 1, 1)
    v = songs.select do |track|
      track.date_added > date && track.date_added < end_year
    end
    puts "#{v.count} new songs in #{year}"
    year_total_duration(v, year)
    find_most_listened_to(v, 10)
    find_most_listened_to_artists(v, 10)
  end

  def self.find_most_listened_to_artists(songs, limit = nil)
    puts "#{limit || 'All'} most listened artists:"
    duration_artist = Hash.new(0)
    songs.each do |song|
      td = song.total_duration
      artists = song.artist.split(/,|;|\/|feat.|ft.|&/i).uniq.map(&:strip)
      artists.each do |artist|
        duration_artist[artist] += td
      end
    end
    i = 0
    duration_artist.sort_by { |k, v| v }.reverse.each do |artist, duration|
      puts "#{duration/60},#{artist}"
      i += 1
      break if i == limit
    end
  end

  def self.year_total_duration(songs, year)
    total_duration = 0
    songs.each do |k|
      total_duration += k.total_duration
    end
    puts "Listened to music from #{year} during #{total_duration} seconds"
    puts "Listened to music from #{year} during #{total_duration / 60} minutes"
    p ActiveSupport::Duration.build(total_duration).parts
  end

  def self.find_most_listened_to(songs, limit = nil)
    puts "#{limit || 'All'} most listened songs:"
    songs.sort_by(&:total_duration).reverse.each_with_index do |track, i|
      puts "#{track.total_duration / 60}: #{track.name} - by #{track.artist}"
      break if i == limit
    end
  end
end
