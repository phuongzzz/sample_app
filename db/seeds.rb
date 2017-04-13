User.create!(name: "phuong",
  email: "yesterdayoncemore23@gmail.com",
  password: "phuongphuong",
  password_confirmation: "phuongphuong",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

30.times do |n|
  name  = Faker::Name.name
  email = "phuong-#{n+1}@gmail.com"
  password = "phuongphuong"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(3)
  users.each { |user| user.microposts.create!(content: content) }
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow(followed)}
followers.each {|follower| follower.follow(user)}
