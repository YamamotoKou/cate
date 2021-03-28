User.create!(name:  "guruman",
             email: "example@cate.com",
             catena_id: "catena",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             avatar: File.open('./app/assets/images/guruman.jpg'),
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "guruman1",
             email: "example1@cate.com",
             catena_id: "katena",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             avatar: File.open('./app/assets/images/naruman.jpeg'),
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

users = User.order(:created_at).take(2)
150.times do
  content = "わあ！こりゃ美味しいなあ！"
  users.each{ |user| user.microposts.create!(content: content)}
end

user = User.first
user.follow(User.second)
follower = User.second
follower.follow(user)

# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }