class Message < ActiveRecord::Base

after_save do |message|
    
    ServerFactory::SURFBOARD.send_request("?req=addMarker&position=#{message.latitude},#{message.longitude}")
  end
end
