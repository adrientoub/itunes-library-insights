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
    find_most_listened_to_duration(v, 10)
    find_most_listened_to_count(v, 10)
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
    duration_string = seconds_to_s(total_duration)
    puts "Listened to music from #{year} during #{duration_string}"
  end

  def self.seconds_to_s(duration)
    duration_parts = ActiveSupport::Duration.build(duration).parts
    str = ''
    ActiveSupport::Duration::PARTS.each do |length|
      if duration_parts[length] > 0
        length_str = if duration_parts[length] == 1; ActiveSupport::Inflector.singularize(length) else length end
        str << "#{duration_parts[length].to_i} #{length_str} "
      end
    end

    str
  end

  def self.find_most_listened_to_count(songs, limit = nil)
    puts "#{limit || 'All'} most listened songs by read count:"
    songs.sort_by(&:read_count).reverse.each_with_index do |track, i|
      puts "#{track.read_count}: #{track.name} - by #{track.artist}"
      break if i == limit
    end
  end

  def self.find_most_listened_to_duration(songs, limit = nil)
    puts "#{limit || 'All'} most listened songs by duration:"
    songs.sort_by(&:total_duration).reverse.each_with_index do |track, i|
      duration = ActiveSupport::Duration.build(track.total_duration).parts
      puts "%02d:%02d: #{track.name} - by #{track.artist}" % [duration[:hours], duration[:minutes]]
      break if i == limit
    end
  end
end
