# iTunes Library Insights

## Overview

Extracts information from iTunes Music Library XML file.
Allows you to get a 'Year in review' summary like what you would get if you
used a streaming service like Spotify.

Currently extracts information about **Music** and **Audiobooks** consumption.

## Setup

To run this you need:
- Ruby 2.6
- Bundler

```sh
bundle install
```

The XML is usually stored in:
- Windows: `C:\Users\<username>\Music\iTunes\iTunes Music Library.xml`
- Mac: `~/Music/iTunes/iTunes Music Library.xml`

## Usage

```sh
ruby insights.rb [library xml path] [year]
```
