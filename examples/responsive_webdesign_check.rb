# -- coding: utf-8

=begin
Usage: ./responsive_webdesign_check.rb [TargetURL]

    $ ruby ./responsive_webdesign_check.rb "http://www.nhk.or.jp/studiopark/"
    640x480 rendering..
    800x600 rendering..
    1024x768 rendering..
    1280x960 rendering..
    1280x1024 rendering..

will save as "screenshots_by_masque/#{size}.png"
See example result: http://imgur.com/a/1MgeF
=end

require "fileutils"
require File.expand_path("../../lib/masque.rb", __FILE__)

url = ARGV.first || "http://www.nhk.or.jp/studiopark/"
dir = "screenshots_by_masque"
FileUtils.mkdir(dir) unless File.directory?(dir)

Masque.run(:driver => :poltergeist) do # webkit always render as full height
  visit url

  %W!640x480 800x600 1024x768 1280x960 1280x1024!.each do |size|
    puts "#{size} rendering.."
    width, height = *size.split("x").map(&:to_i)
    resize width, height
    sleep 1 # wait animation finish
    render "#{dir}/#{size}.png"
    resize width, evaluate_script("document.body.scrollHeight")
    render "#{dir}/#{size}-full.png"
  end
end
