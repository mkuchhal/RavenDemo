require 'patron'

class SurfboardClient

  AUTH_URL = 'https://www.google.com/accounts/ClientLogin'
  LOGIN_URL = 'http://bws-surfboard.appspot.com/_ah/login'
  SERVICE_URL = 'http://bws-surfboard.appspot.com/service'
  HTTP_TXN_TIMEOUT_SECONDS = 50

  def initialize (email, password, app_name)
    @email = email
    @password = password
    @app_name = app_name
    @session = Patron::Session.new
    @session.timeout = HTTP_TXN_TIMEOUT_SECONDS
  end

  # Sends a request and gets back the response. Does not rescue from any exceptions.
  # The data is url-encoded. The parts of the data that are already url-ish are left
  # as they are.
  def send_request (data)
    if (@auth_cookie.nil?)
      login
    end

    if (@auth_cookie)
      @session.base_url = SERVICE_URL
      resp = @session.get(URI.escape(data), {"Cookie" => @auth_cookie})

      puts "########send request", resp

      return resp.body
      
    end
  end

  private

  def login
    auth_token = get_auth_token

    if (auth_token)
      @session.base_url = LOGIN_URL
      
      puts "##########Starting login"

      resp = @session.get("?auth=" + auth_token)
	puts resp.body
      auth_cookie = resp.headers["Set-Cookie"]

      if (auth_cookie && auth_cookie[0][0,6] == "ACSID=")
        @auth_cookie = auth_cookie[0]
      end
    end
  end

  def get_auth_token
    @session.base_url = AUTH_URL
    data = "accountType=GOOGLE&Email=#{@email}&Passwd=#{@password}&service=ah&source=#{@app_name}"
    
	puts "check 1", data

    resp = @session.post("", data)
	puts "check 2", resp.body
    resp.body.each_line do |line|
      if (line[0,5] == "Auth=")
        return (line[5, line.length - 1])
      end
    end
  end
end
