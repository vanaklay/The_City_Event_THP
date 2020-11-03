class UserMailer < ApplicationMailer
  ## Change this to your default email sender
  default from: 'montagne@yopmail.com'
 
  def welcome_email(user)
    @user = user 
    @url  = 'http://monsite.fr/login' 
    mail(to: @user.email, subject: 'Bienvenue chez nous !') 
  end

  def email_to_guest(user, event)
    @user = user 
    @admin = event.admin
    @event = event
    mail(to: @user.email, subject: 'Tu es inscrit(e) à l\'évènement du jour !')
  end

  def email_to_admin(admin, user, event)
    @admin = admin 
    @user = user
    @event = event
    mail(to: @admin.email, subject: 'Une autre personne s\'est inscrite à ton évènement !')
  end
end
