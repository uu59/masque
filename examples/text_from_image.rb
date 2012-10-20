# -- coding: utf-8

=begin
Usage: ./text_from_image.rb [ImageURL]

    $ ruby ./text_from_image.rb "https://assets.github.com/images/icons/emoji/trollface.png"

will put as below:

http://www.google.com/searchbyimage?filter=0&num=100&safe=off&image_url=https%3A%2F%2Fassets.github.com%2Fimages%2Ficons%2Femoji%2Ftrollface.png
http://www.google.com/search?tbs=sbi:AMhZZiv_1UzO9L3jB0q1kxd1EWjYqzQAYTqDj2995tv6uOgUgbjblvKBcb5tpLrNVO_1sFMhvYv2-q97rqK1-PBFyL8AhiskxGtR12nPu_1ei2H4IcoaAwd76Z-TRvjx8zD_1YWwFMJwGdhGnmV1pzXpqd68JK9wypWDgXhk3mhDzyNCBhQb6ahCzCzZIW5CefUKV8gv43Se4XuHXuxYB3_1cXkZkV5DMdEurDFVEs1R_1H2J6xVg-10g8tglowPxoaML866mnpy5bH3REOidP4QUN34pKIztahEYpJYCQN_1Y2ffXhp19HljhELwl_1Q2_1MuD_1XWGS4jFkyXoj6fyX0P9f3hH5mwW_1mKsRc3IgP0UMJ1sB8gZvngr-q4ZnhKbRDJHXj3nDhWUKg1kueVecwTC59nTENiY4uGh9rCh-sKMikcouRh8Fpn8pE4RT-JDC833St3w6Rq13K-HcaRXb2wK7mgSW25607IbfMqNJRAj_1wBkURIHabrZUEN3pUySYZClkxzXnqVW9BfdKG0dvhqxSRaRLiZcC7OX8NW6H7SwUvEGazZg8aFbQSfchKLVEbWt4LmwFordrVDna4p6t3-qnZmqYsvCjJC418xEaF19Pzdt6xkskmacGyEvg-4P1S0YbFd5VJ6RdTtktn5JJrjj0IzRyWbfOvrm-l9-S7aukOK93vanf3MnJDE_1spr372aH0yK5-tJ68h3R0lgXFmqb0q6mvTomq4JMMMZgQnD-qSy_1etIZ9EkRsX62qHyG_17OBNcOl44YYHx8hGRHLuWW4PCxMlogPT7HOpAHG2OS1pAH7iGaWSujlk6ZZCP1ajXniZhGy7XI5BhcdkzCO7FIMjg75IDLbDHWcW79i31Dt8FtUJMWQkc2tshL2CZSF12AazE2fp-a7wQp7T8AzseiGpC2xVBXZtGZ5tQJoKMdw_1j-f3PJHbAe-64HL7NikFOIXiYVsQTcz2a018SxAiG_1LeVtxPyuUTdj6BziRb4uhPS5Tnv4SGEbRR9pMhBq_149OD_1iPyUeCM0HEt-wOkuBk0-lpr33QYAVHue41Rh6kJrb-pHvkVG32WP2XNJxuPW_1sPqETwJ1mFNJ-SIrDow-zPlB13C7Y8ZC-IWF-hX6WmyeGnYG7Fg2LwIQp2FCvWkt-W9Q9BGuy0vNWGyqFVZrhWM_1u-lUxBg0nIPawtqk2EBPdUHf4iSC1pVcVVUi7CFc_1BTkwBeGlkyU1Iylt7PTbfo4J5q0AUJyD8LyrPeTXknMGsy8KioKJwDFhYQGd42gHo2xo28dmhQqulLycBqQozBZ5uTsne2z1dkNUdJlC6PdrXpkeFyGEorvkmRCb3cXQge6yTAfOew45cD-&filter=0&num=100&safe=off
["trollface face photos - Photobucket",
 "trolling face photos - Photobucket",
 "Amazon.com: Troll Face Meme Face Large Bumper Sticker Decal ...",
 "trollface Cancel - TinyPic",
 "Amazon.com: Troll Face Meme Face Small Bumper Sticker Decal ..."]

=end

require File.expand_path("../../lib/masque.rb", __FILE__)
require "pp"

imageurl = ARGV.first || "https://assets.github.com/images/icons/emoji/trollface.png"
googleurl = "http://www.google.com/searchbyimage?filter=0&num=100&safe=off&image_url=#{URI.encode_www_form_component(imageurl)}"

anchors = Masque.run(:driver => :webkit) do
  page.driver.header "User-Agent", "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)"
  page.driver.header "Accept-Language", "en-US;"

  puts googleurl
  visit googleurl
  puts current_url
  evaluate_script <<-JS
    (function(){
      var links = document.querySelectorAll('td h3 a');
      return Array.prototype.map.call(links, function(a){
        return a.textContent || "";
      });
    })();
  JS
end

pp anchors
