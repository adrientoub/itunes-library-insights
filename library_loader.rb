require 'plist'
require 'json'
require './music'

class LibraryLoader
  def self.parse(file)
    songs = []
    books = []
    plist = Plist.parse_xml(file)

    tracks = plist['Tracks']

    plist['Playlists'].each do |playlist|
      if playlist['Music']
        playlist['Playlist Items'].each do |item|
          v = tracks[item['Track ID'].to_s]
          if v['Album'] != 'Mémos vocaux'
            songs << Music.from_plist(v) rescue p v
          end
        end
      elsif playlist['Audiobooks']
        playlist['Playlist Items'].each do |item|
          v = tracks[item['Track ID'].to_s]
          books << Music.from_plist(v) rescue p v
        end
      end
    end

    {
      tracks: songs,
      books: books,
    }
  end

  def self.load(filename)
    json_path = "#{filename}.json"
    if File.exists?(json_path)
      library = JSON.parse(File.read(json_path))
      {
        tracks: to_track_list(library['tracks']),
        books: to_track_list(library['books']),
      }
    else
      file = File.read(filename)
      tracks = parse(file)
      dump(tracks, json_path)
      tracks
    end
  end

  def self.to_track_list(tracks)
    tracks.map do |t|
      Music.to_track(t)
    end
  end

  def self.dump(tracks, json_path)
    File.open(json_path, 'w') do |file|
      file.puts JSON.dump(tracks)
    end
  end
end
