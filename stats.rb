require 'active_support/duration'

class Stats
  def self.generate_stats(songs, year)
    date = DateTime.new(year, 1, 1)
    end_year = DateTime.new(year + 1, 1, 1)
    v = songs[:tracks].select do |track|
      track.date_added > date && track.date_added < end_year
    end
    puts "#{v.count} new songs in #{year}"
    display_total_duration(v, "music from #{year}")
    find_most_listened_to_duration(v, 10)
    find_most_listened_to_count(v, 10)
    find_most_listened_to_artists_duration(v, 10)
    find_most_listened_to_artists_count(v, 10)

    books = songs[:books]
    unless books.empty?
      display_total_books_duration(books, 'books')
      find_longest_listened_album_duration(books, 10)
      find_most_listened_to_artists_duration(books, 10)
    end
  end

  def self.find_most_listened_to_artists_duration(songs, limit = nil)
    puts "#{limit || 'All'} most listened artists by duration:"
    duration_artist = Hash.new(0)
    songs.each do |song|
      td = song.total_duration
      artists = song.artist.split(/,|;|\/|feat.|ft.|&|-/i).uniq.map(&:strip)
      artists.each do |artist|
        duration_artist[artist] += td
      end
    end
    i = 0
    duration_artist.sort_by { |k, v| v }.reverse.each do |artist, duration|
      puts "#{duration_to_short_string(duration)},#{artist}" if duration > 0
      i += 1
      break if i == limit
    end
  end

  def self.find_most_listened_to_artists_count(songs, limit = nil)
    puts "#{limit || 'All'} most listened artists by count:"
    count_artist = Hash.new(0)
    songs.each do |song|
      artists = song.artist.split(/,|;|\/|feat.|ft.|&/i).uniq.map(&:strip)
      artists.each do |artist|
        count_artist[artist] += song.read_count
      end
    end
    i = 0
    count_artist.sort_by { |k, v| v }.reverse.each do |artist, count|
      puts "#{count},#{artist}"
      i += 1
      break if i == limit
    end
  end

  def self.find_longest_listened_album_duration(songs, limit = nil)
    puts "#{limit || 'All'} longest listened albums by duration:"
    duration_album = Hash.new(0)
    artist_album = {}
    songs.each do |song|
      duration_album[song.album] += song.duration if song.read_count > 0
      artist_album[song.album] = song.artist
    end
    i = 0
    duration_album.sort_by { |k, v| v }.reverse.each do |album, duration|
      puts "#{duration_to_short_string(duration)},#{album},#{artist_album[album]}"
      i += 1
      break if i == limit
    end
  end

  def self.display_total_duration(songs, type)
    total_duration = 0
    songs.each do |k|
      total_duration += k.total_duration
    end
    duration_string = seconds_to_s(total_duration)
    puts "Listened to #{type} during #{duration_string}"
  end

  def self.display_total_books_duration(songs, type)
    total_duration = 0
    songs.each do |k|
      total_duration += k.duration if k.read_count > 0
    end
    duration_string = seconds_to_s(total_duration)
    puts "Listened to #{type} during #{duration_string}"
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
      puts "#{duration_to_short_string(track.total_duration)}: #{track.name} - by #{track.artist}"
      break if i == limit
    end
  end

  def self.duration_to_short_string(duration)
    duration_parts = ActiveSupport::Duration.build(duration).parts
    str = ''
    if duration_parts[:weeks] > 0
      str << '%02dw%02dd' % [duration_parts[:weeks], duration_parts[:days]]
    elsif duration_parts[:days] > 0
      str << '%02dd' % duration_parts[:days]
    end
    str << '%02dh%02d' % [duration_parts[:hours], duration_parts[:minutes]]
    str
  end
end
