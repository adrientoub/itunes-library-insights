class Music
  attr_accessor :name, :artist, :album, :duration, :read_count, :date_added

  def initialize(name, artist, album, duration, read_count, date_added)
    @name = name
    @artist = artist
    @album = album
    @duration = duration
    @read_count = read_count
    @date_added = date_added
  end

  def total_duration
    return @duration * @read_count if @duration && @read_count
    0
  end
end
