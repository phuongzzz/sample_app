User.create!(name: "phuong",
  email: "yesterdayoncemore23@gmail.com",
  password: "phuongphuong",
  password_confirmation: "phuongphuong",
  admin: true)

10.times do |n|
  name  = Faker::Name.name
  email = "phuong-#{n+1}@gmail.com"
  password = "phuongphuong"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
