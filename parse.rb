require 'plist'
require './music'

class Parse
  def self.parse(file)
    musics = []
    plist = Plist.parse_xml(file)
    plist['Tracks'].each do |_, v|
      unless v['Podcast'] || v['Location']&.include?('Downloads/books') || v['Name'].include?('enregistrement')
        musics << Music.new(v['Name'], v['Artist'], v['Album'], v['Total Time'] / 1000, v['Play Count'], v['Date Added']) rescue p v
      end
    end
    musics
  end
end
