require 'plist'
require 'json'
require './music'

class LibraryLoader
  def self.parse(file)
    musics = []
    plist = Plist.parse_xml(file)

    tracks = plist['Tracks']

    plist['Playlists'].each do |playlist|
      if playlist['Music']
        playlist['Playlist Items'].each do |item|
          v = tracks[item['Track ID'].to_s]
          if v['Album'] != 'Mémos vocaux'
            musics << Music.new(v['Name'], v['Artist'], v['Album'], v['Total Time'] / 1000, v['Play Count'], v['Date Added']) rescue p v
          end
        end
      end
    end

    musics
  end

  def self.load(filename)
    json_path = "#{filename}.json"
    if File.exists?(json_path)
      library = JSON.parse(File.read(json_path))
      library.map do |track|
        Music.new(track['name'], track['artist'], track['album'], track['duration'], track['read_count'], DateTime.parse(track['date_added']))
      end
    else
      file = File.read(filename)
      tracks = parse(file)
      dump(tracks, json_path)
      tracks
    end
  end

  def self.dump(tracks, json_path)
    File.open(json_path, 'w') do |file|
      file.puts JSON.dump(tracks)
    end
  end
end
