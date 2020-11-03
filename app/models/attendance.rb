class Attendance < ApplicationRecord
  after_create :send_emails
  belongs_to :user
  belongs_to :event

  def send_emails
    UserMailer.email_to_admin(self.event.admin, self.user, self.event).deliver_now
    UserMailer.email_to_guest(self.user, self.event).deliver_now
  end
end
