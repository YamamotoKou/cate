class DirectMessagesController < ApplicationController
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:direct_message][:room_id]).present?
      @directmessage = DirectMessage.new(direct_message_params)
      @directmessage.save
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
    end
    redirect_to "/rooms/#{@directmessage.room_id}"
  end

  private

    def direct_message_params
      params.require(:direct_message).permit(:user_id, :room_id, :message).merge(user_id: current_user.id)
    end
end