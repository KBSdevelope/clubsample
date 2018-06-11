class PlaylistController < ApplicationController
    require "net/http"
   # GET /users
   def index
     url = "http://..."
     resp = Net::HTTP.get_response(URI.parse("http://a98952108bd50135ea8c543d7edaf0a0.scheduler.vidibus.net/api/channels/5aa6722c1d0a7e7578e21c1d/playlist.json"))
       @playlist = []
     @data = JSON.parse(resp.body)
     #render json: playlists(@data)
     render json: playlists(@data)
     #playlists(@data)
      # @source = [@data["playlist"]["sources"]]
    # @users = User.all
   end

   private
    def playlists(data)
      range = ((DateTime.now-100.days).to_date..(DateTime.now + 5.days).to_date)
      schedules = @data["playlist"]["schedule"].select{ | s | (range).include? (DateTime.strptime(s["starts_at"], '%Y-%m-%d T%H:%M:%S%z').to_date)}
      sources = @data["playlist"]["sources"]
      response = []
        schedules.map do|schedule|
          response = sources.find{|data| data["id"] = schedule["source"]}
          source_url = response.nil? ? "" : response["url"]
          schedule["url"] = source_url
        end
        schedules.map{|data| data.except("id","asset", "source")}
      # {"playlist":{"schedule": schedules}}
    end
end
