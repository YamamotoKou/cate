user1 = User.create!(name:  "guruman",
             email: "example@cate.com",
             catena_id: "catena",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
user1.avatar.attach(io: File.open(Rails.root.join('app/assets/images/yamamoto.jpg')),
                    filename: 'yamamoto.jpg')

user2 = User.create!(name:  "guruman1",
             email: "example1@cate.com",
             catena_id: "katena",
             password:              "meshiuma",
             password_confirmation: "meshiuma",
             admin: false,
             activated: true,
             activated_at: Time.zone.now)
user2.avatar.attach(io: File.open(Rails.root.join('app/assets/images/naokosan.jpg')),
                    filename: 'naokosan.jpg')

users = User.order(:created_at).take(2)
#投稿を作成
40.times do
  text = "おはようございます"
  users.each{ |user| user.microposts.create!(text: text)}
end

#投稿内容にコンテンツを作成       
microposts = Micropost.all
microposts.each{ |micropost| 
                  micropost.contents.create!(title: "撮影方法",
                                             sentence: "niconのカメラ",
                                             price: 300,
                                             status: 1)
                  micropost.image.attach(io: File.open(Rails.root.join('app/assets/images/ajisai.jpg')), filename: 'ajisai.jpg')}

# TransactionLog.create!(content_id: 1,
#                        buyer_id: 2,
#                        seller_id: 1)
                                
# #各ユーザーに初期ポイント１０００ポイントを設定
# users.each{ |user| user.point_histories.create!(amount: 1000,
#                                                 transaction_log_id: 0)}

#フォロー関係を作成
user = User.first
user.follow(User.second)
follower = User.second
follower.follow(user)

# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }