class Message < ActiveRecord::Base

after_save do |message|
    
    puts "#########TEST######## " 
    ServerFactory::SURFBOARD.send_request("?req=addMarker&position=#{message.latitude},#{message.longitude}")
    puts "#####TEST####"
  end
end
