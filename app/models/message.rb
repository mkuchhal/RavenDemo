class Message < ActiveRecord::Base

validates :Messagetext, :presence =>true
validates :Latitude, :presence =>true
validates :Longitude, :presence =>true
validates :Sendername, :presence =>true
validates :Recepientname, :presence =>true


after_save do |message|
    
    puts "#########TEST######## " 
    ServerFactory::SURFBOARD.send_request("?req=addMarker&position=#{message.latitude},#{message.longitude}")
    puts "#####TEST####"
  end
end
