class EgpProgram
 def self.fetch_schedule(data_value)
   range = ((DateTime.now-100.days).to_date..(DateTime.now + 5.days).to_date)
   schedules = data_value["playlist"]["schedule"].select{ | s | (range).include? (DateTime.strptime(s["starts_at"], '%Y-%m-%d T%H:%M:%S%z').to_date)}
   sources = data_value["playlist"]["sources"]
   response = []
     schedules.map do|schedule|
       response = sources.find{|data| data["id"] = schedule["source"]}
       source_url = response.nil? ? "" : response["url"]
       schedule["url"] = source_url
     end
   schedules.map{|data| data.except("id","asset", "source")}
 end
end
