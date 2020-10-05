User.create!(name:  "guruman",
             email: "example@cate.com",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             image: File.open('./app/assets/images/guruman.jpg'),
             admin: true)

User.create!(name:  "guruman1",
             email: "example1@cate.com",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             image: File.open('./app/assets/images/naruman.jpeg'))
