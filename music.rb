class Music
  attr_accessor :name, :artist, :album, :duration, :read_count, :date_added, :play_date

  def initialize(name, artist, album, duration, read_count, date_added, play_date)
    @name = name
    @artist = artist
    @album = album
    @duration = duration
    @read_count = read_count || 0
    @date_added = date_added
    @play_date = play_date
  end

  def total_duration
    return @duration * @read_count if @duration && @read_count
    0
  end

  def artists
    self.artist.split(/,|;|\/|feat.|ft.|&/i).uniq.map(&:strip)
  end

  def as_json(options={})
    {
      name: name,
      artist: artist,
      album: album,
      duration: duration,
      read_count: read_count,
      date_added: date_added,
      play_date: play_date,
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  def self.from_plist(track)
    Music.new(track['Name'],
              track['Artist'],
              track['Album'],
              track['Total Time'] / 1000,
              track['Play Count'],
              track['Date Added'],
              track['Play Date UTC'])
  end

  def self.to_track(track)
    Music.new(track['name'],
              track['artist'],
              track['album'],
              track['duration'],
              track['read_count'],
              DateTime.parse(track['date_added']),
              track['read_date'] ? DateTime.parse(track['read_date']) : nil)
  end
end
