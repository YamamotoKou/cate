class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインを行ってください"
        redirect_to login_url
      end
    end

    # ユーザーがログアウトしていればtrue、その他ならfalseを返す
    def logged_out_user?
      unless current_user.nil?
        flash[:danger] = "ログイン済みです"
        redirect_to home_url
      end
    end
end