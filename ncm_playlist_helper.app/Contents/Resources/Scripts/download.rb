if ARGV.length != 2
    raise ArgumentError, "必须传入两个参数"
    exit 1
end

require 'net/http'
require 'json'
require 'csv'

id, file = ARGV

url = "http://music.163.com/api/playlist/detail?id=#{id}"
uri = URI(url)
response = Net::HTTP.get(uri)
json = JSON.load(response)
tracks = json["result"]["tracks"]

CSV.open(file, 'w') do |csv| 
    csv << ["play", "id", "name", "album", "artists"]
    tracks.map {  |t|
        id, name, artists, album = t["id"], t["name"], t["artists"], t["album"]["name"]
        play = "=HYPERLINK(\"ncm://#{id}\",\"►Play\")"
        url = "=HYPERLINK(\"http://music.163.com/song/#{id}\",\"#{id}\")"
        artists = artists.map{|a| a["name"]}.join("/")
        csv << [play, url, name, album, artists]
    }
end