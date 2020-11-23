User.create!(name:  "guruman",
             email: "example@cate.com",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             image: File.open('./app/assets/images/guruman.jpg'),
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

users = User.order(:created_at).take(2)
20.times do
  content = "わあ！こりゃ美味しいなあ！"
  users.each{ |user| user.microposts.create!(content: content)}
end

User.create!(name:  "guruman1",
             email: "example1@cate.com",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             image: File.open('./app/assets/images/naruman.jpeg'),
             activated: true,
             activated_at: Time.zone.now)

