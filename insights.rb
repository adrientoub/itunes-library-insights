#! /usr/bin/env ruby

require './library_loader'
require './stats'

def print_usage
  $stderr.puts 'Usage: ./insights.rb [itunes-library.xml] [YEAR]'
  exit(1)
end

if ARGV.size == 0
  print_usage
else
  tracks = LibraryLoader.load(ARGV[0])
  Stats.generate_stats(tracks, ARGV[1].to_i || Date.now.year)
end
