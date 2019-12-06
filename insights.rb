#! /usr/bin/env ruby

require './parse'
require './stats'

def print_usage
  $stderr.puts 'Usage: ./insights.rb [itunes-library.xml] [YEAR]'
  exit(1)
end

if ARGV.size == 0
  print_usage
else
  file = File.read(ARGV[0])
  tracks = Parse.parse(file)
  Stats.generate_stats(tracks, ARGV[1].to_i || Date.now.year)
end
