require 'faker'

## Create 5 fakes users
# 5.times do 
#   first_name = Faker::Name.first_name
#   last_name = Faker::Name.last_name
#   User.create(first_name: first_name, 
#     last_name: last_name, 
#     description: Faker::JapaneseMedia::OnePiece.quote,
#     email: first_name + "_" + last_name + "@yopmail.com",
#     password: "azerty"
#   )
# end

## Create 12 events 
12.times do
  Event.create(start_date: DateTime.now + 3, duration: 25,
    title: Faker::Games::Zelda.game  + "!!!" ,
    description: Faker::TvShows::BigBangTheory.quote + " and " + Faker::TvShows::BigBangTheory.quote,
    price: Faker::Number.between(from: 1, to: 1000),
    location: Faker::Games::Zelda.location,
    admin: User.all.sample
  )
end


