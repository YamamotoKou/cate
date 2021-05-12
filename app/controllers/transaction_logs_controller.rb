class TransactionLogsController < ApplicationController
  def create

    @content = Content.find(params[:content_id])
    @micropost = Micropost.find(@content.micropost_id)

    if enough_point?
      #取引ログ
      @transaction_logs = @content.transaction_logs.create!(amount: @content.price, 
                                                           buyer_id: current_user.id,
                                                           seller_id: params[:seller_id])

      #購入者ポイントログ
      buy_point = @transaction_logs.point_histories.create!(amount: -@transaction_logs.amount,
                                                            user_id: @transaction_logs.buyer_id)

      #販売者ポイントログ
      sell_point = @transaction_logs.point_histories.create!(amount: @transaction_logs.amount,
                                                             user_id: @transaction_logs.seller_id)

      point_count

      flash[:danger] = "コンテンツを購入しました。所持ポイントは#{@point_sum}ポイントです。"
      redirect_to micropost_contents_url(@micropost)
    else
      flash[:danger] = "所持ポイントは#{@point_sum}ポイントです。ポイントが足りません。[ポイント購入]は現在準備中のため、システム完成までお待ちください。"
      redirect_to micropost_contents_url(@micropost)
    end

  end

  private

    def enough_point?
      point_count
      @content.price <= @point_sum
    end

    def point_count
      @point_sum = current_user.point_histories.sum(:amount) + 10000
    end

end