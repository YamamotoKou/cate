User.create!(name:  "guruman",
             email: "example@cate.com",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             image: File.open('./app/assets/images/guruman.jpg'),
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "guruman1",
             email: "example1@cate.com",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             image: File.open('./app/assets/images/naruman.jpeg'),
             activated: true,
             activated_at: Time.zone.now)
