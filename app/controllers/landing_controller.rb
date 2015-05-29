class LandingController < ApplicationController
  def enter
	  loggedIn = session[:loggedIn]
	  if(loggedIn == true)
		render 'main/browse'
	  else
		render 'enter'
	  end
  end
  
  
  def test
	password = params['pass']
	username = params['user']
	if username == 'admin' and password == Rails.application.secrets.user_pass
		session[:loggedIn] = true
		redirect_to '/'
	else
		redirect_to '/'
	end
	
	
  end
end
