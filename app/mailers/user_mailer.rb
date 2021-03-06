class UserMailer < ActionMailer::Base
  default from: "support@coachatlas.com"

  def welcome_email(user)
    @user = user
    @url  = "http://coachatlasv3.herokuapp.com/users/sign_in"
    mail(:to => user.email, :subject => "Welcome to CoachAtlas")
  end
end
