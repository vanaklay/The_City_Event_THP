# The City Event
![](https://appsforevents.org/wp-content/uploads/2019/07/appsforevents.org-eventbrite-event-management-software-eventbrite-ios.jpg)

Create virtual room to meet your friend !

## To enjoy ➡️ [Go there](https://fast-sands-08162.herokuapp.com)

### fakes accounts
* email: lupita_conroy@yopmail.com / password: azerty
* email: mireille_rohan@yopmail.com / password: azerty
* email: branda_hamill@yopmail.com / password: azerty

### Testing emails
You can test emails sent in [yopmail.com](www.yopmail.com) 

## Author
* Make real with 💪 and 😭 by my team : [Maxime](https://github.com/Mtwod), [Coline](https://github.com/colinebrlt), [Arthur](https://github.com/Rudyar) and Me !




# Create an app with rails 5.2.3 or 6.0
## 1 - Rails versions 
If you want to create an app with last rail version and PostgreSql like database in development:
```shell
$ rails new -d postgresql app_name
```
If you want to create an app with rails version 5.2.3 and PostgreSql:
> Tips: I recommand to create this app with this rails version because we found many conflicts with rails 6. But it's you're choice !
```shell
"rails _5.2.3_ new -d postgresql"
```
## 2 - Add Gems into gemfile

  - Add `dotenv` to aware `.env` file
```ruby
gem 'dotenv-rails'
```
  - Add gem `letter_opener` in development group to send emails to browser
 ```ruby
gem 'letter_opener'
```
- Add gem `table_print` to nicely display tables in rails console
```ruby
gem 'table_print'
```
- Add gem `devise` to create authentication systeme
```ruby
gem 'devise'
```

Run `bundle install` to create a gemfile.lock to store all dependencies that your app needed.

## 3 - Think about database
### 3.1 - Create models
For this database, we see three models:
* A `User` model, which represents the users of our site
* An `Event` model, which represents the events of our site
* An `Attendance` model, which represents participation in an event. It is the join table between the events and the participants in an event.

We use `rails generator` to create the last two models but we use devise to create the `User` model but first we need to create an PostgreSQL database:
```shell
$ rails db:create
```
then the models:

```shell
$ rails generate model Event 
$ rails generate model Attendance
```

Then install `devise` with the following command:
```shell
$ rails generate devise:install
```
Check if this line is in `config/environments/development.rb`:
```shell
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
Generate our `User` model with devise:
```shell
rails g devise User
```
It is a migration to create a users table, then add the attributes that will be used for Parameter `devise`.

### 3.2 - Complete validations and attributs in the tables

#### 3.2.1 `User` model
His migration - `db/migrate/XXX_create_users.rb` or `db/migrate/XXX_change_users.rb`:
```ruby
# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Custom database authenticatable
      t.text :description
      t.string :first_name
      t.string :last_name

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at


      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
```
And his class `User` - `app/models/user.rb`:
```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  after_create :welcome_send
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, 
    presence:true, 
    uniqueness: true, 
    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "email adress please" }
  validates :description, presence: true

  has_many :attendances
  has_many :events, through: :attendances
  has_many :admins, foreign_key: 'admin_id', class_name: "Event", dependent: :destroy

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
end
```

#### 3.2.1 `Event` model
His migration - `db/migrate/XXX_create_events.rb`:
```ruby
class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.datetime :start_date
      t.integer :duration
      t.string :title
      t.text :description
      t.integer :price
      t.string :location
      t.references :admin, index: true
      
      t.timestamps
    end
  end
end
```
And his class - `app/models/event.rb`:
```ruby
class Event < ApplicationRecord
  validates :start_date, presence: true, if: :future_date
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }, if: :multiple_of_five?
  validates :title, presence: true, length: {in: 5..140}
  validates :description, presence: true, length: {in: 20..1000}
  validates :price, presence:true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
  validates :location, presence: true

  has_many :attendances
  has_many :users, through: :attendances
  # class_name method
  belongs_to :admin, class_name: "User"

  def multiple_of_five?
    errors.add(:duration, "should be a multiple of 5.") unless duration % 5 == 0
  end

  def future_date
    errors.add(:start_date, "Event can't be in the past") unless start_date > DateTime.now
  end
end
```
#### 3.2.1 `Attendance` model
His migration - `db/migrate/XXX_create_attendances.rb`:
```ruby
class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.string :stripe_customer_id
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
```
And his class - `app/models/attendance.rb`:
```ruby
class Attendance < ApplicationRecord
  after_create :send_emails
  belongs_to :user
  belongs_to :event

  def send_emails
    UserMailer.email_to_admin(self.event.admin, self.user, self.event).deliver_now
    UserMailer.email_to_guest(self.user, self.event).deliver_now
  end
end
```
After creating these models, do not forget to migrate all of these:
```shell
$ rails db:migrate
```

### 4 - Mailer
In order to send emails, we need to config `actionMailer`.
#### 4.1 - Generate an `ActionMailer`
```shell
$ rails g mailer UserMailer
```
Edit the class UserMailer that we just created - `app/mailers/user_mailer.rb`:
```ruby
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
```
#### 4.2 - Generate the view of the emails
Create a file that has the same name of the methods in `user_mailer.rb`.
For example - `welcome_email.html.erb`:
```ruby
<h1>Salut <%= @user.first_name %> et bienvenue chez nous !</h1>
<p>
    Tu t'es inscrit sur monsite.fr en utilisant l'e-mail suivant : <%= @user.email %>.
</p>
<p>
    Pour accéder à ton espace client, connecte-toi via : <%= @url %>.
</p>
<p> À très vite sur monsite.fr !</p>
```
#### 4.3 - Define when our Rails app should send
In the class `User`, we call the method `welcome_email` define in the class `UserMailer` to send an email when the user is created:
```ruby
class User < ApplicationRecord
    # Use Callback to apply method after creating new user
  after_create :welcome_send
  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
end
```
#### 4.4 - Send an email in development environment
Use the gem `letter_opener` to open the email sent in your browser.
Setup `config/environments/development.rb` to activate this process with adding this command:
```ruby
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.perform_deliveries = true
```
#### 4.5 - Send an email in production environment
### 4.5.1 - Have a SendGrid api key
We use `SendGrid` services to send our emails.
You need to create an account and then create a first sender to validate your process.
Save your SendGrid login and SendGrid password in your `.env` file:
```ruby
SENDGRID_LOGIN='apikey'
SENDGRID_PWD='YOUR_PWD_API_KEY_FROM_SENDGRID'
```
Do not forget to include the `.env` file in your `.gitignore` file to evoid sharing your api keys !
#### 4.5.2 - Setup the SMTP 
All you have to do is enter the SendGrid SMTP settings into your app. Go to `/config/environment.rb` and add the following lines:
```ruby
ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_LOGIN'],
  :password => ENV['SENDGRID_PWD'],
  :domain => 'monsite.fr',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
```
#### 4.5.3 - Setup Heroku 
If you use Heroku to deploy your app, please follow this lines:

* Create a remote with heroku and your app:
```shell
$ heroku create
```


* Create a log with your SENDGRID account:
```shell
$ heroku config:set SENDGRID_PWD='YOUR_API_KEY'
$ heroku config:set SENDGRID_LOGIN='apikey'
```


* Push on heroku your app:
```shell
$ git push heroku master
```

You don't need to create a database because its already done by heroku and it uses PostgreSql for you. Just run the migration:
```sh
$ heroku run rails db:migrate
```

> Tips: Create one type of each model in the console to test the creation process before doing your seed !


* Run a rails console inside your heroku account with this line and test if all work:
```shell
$ heroku run rails console
```

## 5 - Views with `devise`
With Devise, it is easy to generate the views that the gem will manage, just enter the following line:
```sh
$ rails generate devise:views
```

### 5.1 - Mailer with `Devise`
In this `config/environments/production.rb`, add these lines:
```ruby
config.action_mailer.default_url_options = { :host => 'YOURAPPNAME.herokuapp.com' }
```
You must give the url of your application for the redirection.

### 5.2 - Create the homepage
We will do the first view of the application: the home page.
```sh
$ rails g controller static_pages index
```








