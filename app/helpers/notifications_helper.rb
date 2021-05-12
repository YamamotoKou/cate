module NotificationsHelper
  def notification_form(notification)
    @sender = notification.sender
    case notification.action
    when 'follow'
      tag.a(notification.visitor.name, href: user_path(@sender)) + 'があなたをフォローしました'
    when 'like'
      tag.a(notification.visitor.name, href: user_path(@sender)) + 'が' + 
        tag.a('あなたの投稿', href: micropost_contents_path(notification.micropost_id)) + 'にいいねしました'
        micropost = Micropost.find_by(id: notification.micropost_id)
        @micropost_title = micropost.title
    when 'transaction' then
      tag.a(notification.visitor.name, href: user_path(@sender)) + 'が' + 
        tag.a('あなたのコンテンツ', href: micropost_contents_path(notification.micropost_id)) + 'を購入しました'
    end
  end
end